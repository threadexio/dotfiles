{ self, config, pkgs, lib, ... }: with lib;
let
  cfg = config.custom.services.watchpuppy;
in
{
  options = {
    custom.services.watchpuppy = {
      enable = mkEnableOption "sleep when a user is not logged in";

      user = mkOption {
        type = types.str;
        description = mdDoc ''
          Sleep if this user is not logged in.
        '';
        example = "myuser";
      };

      timeout = mkOption {
        type = types.ints.unsigned;
        description = mkDoc ''
          Check if the user is logged in every `x` seconds.
        '';
        default = 5 * 60;
        example = 500;
      };
    };
  };

  config = mkIf cfg.enable (
    let
      watchpuppy = self.packages.${pkgs.system}.watchpuppy;
    in
    {
      systemd.services.watchpuppy = {
        description = "Sleep when user not logged in";
        after = [ "sshd.service" ];

        serviceConfig = {
          Type = "simple";
          ExecStart = "${watchpuppy}/bin/watchpuppy -u ${escapeShellArg cfg.user} -t ${escapeShellArg cfg.timeout}";
        };

        wantedBy = [ "multi-user.target" ];
      };

      environment.systemPackages = [ watchpuppy ];
    }
  );
}
