{ self
, inputs
, ...
}:

let
  inherit (inputs.nixpkgs) lib;

  nixosConfiguration =
    { hostName
    , extraModules ? [ ]
    , ...
    }:
    let
      specialArgs = {
        inherit self inputs;
        inherit hostName;
      };

      nixosModules = [
        {
          networking.hostName = hostName;
        }
        ./${hostName}
      ];

      sopsNixModules = lib.optionals (lib.pathExists ./${hostName}/secrets.yaml) [
        inputs.sops-nix.nixosModules.sops
        (
          { pkgs, lib, ... }:
          {
            environment.systemPackages = [ pkgs.sops ];

            sops.defaultSopsFile = ./${hostName}/secrets.yaml;
            sops.age.keyFile = "/var/lib/sops-nix/key.txt";
            systemd.tmpfiles.settings."10-sops-nix" = {
              "/var/lib/sops-nix".d = {
                user = "root";
                group = "root";
                mode = "0700";
              };
            };

            _module.args.sopsSecretsFrom =
              path: secrets:
              lib.mapAttrs
                (
                  secret: options:
                  options
                  // {
                    sopsFile = path;
                  }
                )
                secrets;
          }
        )
      ];

      homeManagerModules = lib.optionals (lib.pathExists ./${hostName}/home.nix) [
        inputs.hm.nixosModules.default
        (
          { config
          , lib
          , pkgs
          , ...
          }:
          {
            users.mutableUsers = false;
            programs.zsh.enable = true;
            environment.pathsToLink = [ "/share/zsh" ];

            home-manager.useGlobalPkgs = true;
            home-manager.extraSpecialArgs = specialArgs // {
              nixosConfig = config;
            };

            users.users.kat = {
              description = "kat";
              isNormalUser = true;

              home = "/home/kat";
              createHome = true;
              homeMode = "700";

              shell = pkgs.zsh;
              extraGroups = [
                "wheel"
              ]
              ++ (lib.optional config.networking.networkmanager.enable "networkmanager")
              ++ (lib.optional config.virtualisation.libvirtd.enable "libvirtd")
              ++ (lib.optional config.programs.wireshark.enable "wireshark")
              ++ (lib.optional config.hardware.i2c.enable "i2c")
              ++ (lib.optional config.virtualisation.podman.enable "podman");

              subUidRanges =
                [ ]
                ++ (lib.optional config.virtualisation.podman.enable {
                  startUid = 100000;
                  count = 65536;
                });

              subGidRanges =
                [ ]
                ++ (lib.optional config.virtualisation.podman.enable {
                  startGid = 100000;
                  count = 65536;
                });

              hashedPassword = "$2b$05$5tpaRElUawEPUuIiWmZDtOpf6l0HmZNHoJsgRBQuGW2T4Wxu.nUE6";
            };

            systemd.tmpfiles.settings."10-kat-private-tmp" = {
              "/tmp/kat".d = {
                user = "kat";
                group = "users";
                mode = "0700";
              };
            };

            home-manager.users.kat.imports = [ ./${hostName}/home.nix ];
          }
        )
      ];

    in
    lib.nixosSystem {
      inherit specialArgs;

      modules = nixosModules ++ sopsNixModules ++ homeManagerModules ++ extraModules;
    };
in

{
  flake.nixosConfigurations = {
    ares = nixosConfiguration {
      hostName = "ares";
    };

    hades = nixosConfiguration {
      hostName = "hades";
    };

    atlas = nixosConfiguration {
      hostName = "atlas";
    };

    cerberus = nixosConfiguration {
      hostName = "cerberus";
    };
  };
}
