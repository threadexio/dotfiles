{ config
, lib
, ...
}:

let
  cfg = config.builder;
in

{
  options = {
    builder = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to optimize the configuration for building packages.
        '';
      };

      cache = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Whether to serve a Nix Binary Cache alongside.
          '';
        };

        keyPath = lib.mkOption {
          type = lib.types.path;
          description = ''
            Path to the key used to sign the binary cache.
          '';
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    nix.nrBuildUsers = 64;
    nix.settings = {
      min-free = 10 * 1024 * 1024;
      max-free = 200 * 1024 * 1024;

      max-jobs = "auto";
      cores = 0;
    };

    systemd.services.nix-daemon.serviceConfig = {
      MemoryAccounting = true;
      MemoryMax = "90%";
      OOMScoreAdjust = 500;
    };

    services.nix-serve = lib.mkIf cfg.cache.enable {
      enable = true;
      secretKeyFile = cfg.cache.keyPath;
      openFirewall = true;
    };
  };
}
