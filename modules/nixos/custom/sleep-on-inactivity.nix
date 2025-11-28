{ config
, pkgs
, lib
, ...
}:

with lib;
let
  cfg = config.services.sleep-on-inactivity;
in

{
  options = {
    services.sleep-on-inactivity = {
      enable = mkEnableOption "sleep on system inactivity";

      poll = mkOption {
        default = "*-*-* *:0/10:00";
        example = "*:0/5:00";
        description = ''
          Check for inactivity this ofter. Accepts systemd's calendar format.
          See: `systemd.time(5)`.
        '';
        type = types.str;
      };

      check = {
        users = {
          enable = mkOption {
            default = true;
            description = ''
              Do not sleep if there are users logged in.
            '';
            type = types.bool;
          };
        };

        tcp = {
          enable = mkOption {
            default = false;
            description = ''
              Do not sleep if there are active TCP connections.
            '';
            type = types.bool;
          };

          ports = mkOption {
            default = [ ];
            example = [
              22
              80
              443
            ];
            description = ''
              Do not sleep if there are active TCP connections on these ports.
            '';
            type = types.listOf types.port;
          };
        };
      };

      extraChecks = mkOption {
        default = [ ];
        description = ''
          Scripts to perform additional checks.
        '';
        type = types.listOf (types.either types.string types.package);
      };
    };
  };

  config =
    let
      mainCheckScript = pkgs.writeShellApplication {
        name = "sleep-on-inactivity-check";

        runtimeInputs = with pkgs; [
          systemd
        ];

        text = ''
          for check in "$@"; do
            if ! "$check"; then
              exit 0
            fi
          done

          systemctl suspend -i
        '';
      };

      checkScripts =
        [ ]
        ++ (lib.optional cfg.check.users.enable (
          pkgs.writeShellScript "sleep-on-inactivity-check-users" ''
            PATH="${lib.makeBinPath (with pkgs; [ coreutils ])}"

            if [ "$(who | wc -l)" -eq 0 ]; then
              exit 0
            else
              exit 1
            fi
          ''
        ))

        ++ (lib.optional (cfg.check.tcp.enable && length cfg.check.tcp.ports > 0) (
          pkgs.writeShellScript "sleep-on-inactivity-check-tcp" ''
            PATH="${lib.makeBinPath (with pkgs; [ coreutils gnugrep gawk iproute2 ])}"

            if [ "$(ss --no-header -tn | awk '{print $4}' | grep ${concatStringsSep " " (map (port: "-e :${toString port}") cfg.check.tcp.ports)} | wc -l)" -eq 0 ]; then
              exit 0
            else
              exit 1
            fi
          ''
        ))
        ++ cfg.extraChecks;
    in
    mkIf cfg.enable {
      systemd.timers."sleep-on-inactivity" = {
        description = "Sleep on inactivity";
        wantedBy = [ "timers.target" ];

        timerConfig = {
          OnCalendar = cfg.poll;
          Persistent = false;
        };
      };

      systemd.services."sleep-on-inactivity" = {
        description = "Sleep on inactivity";
        requires = [ "sleep-on-inactivity.timer" ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = false;
          ExecStart =
            "${lib.getExe mainCheckScript} ${concatStringsSep " " (map toString checkScripts)}";
        };
      };
    };
}
