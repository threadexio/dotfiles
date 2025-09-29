{ inputs
, specialArgs
, ...
}:

let
  inherit (inputs.nixpkgs) lib;
in

{
  flake.nixosConfigurations =
    let
      nixosConfiguration =
        hostName:
        let
          hasHome = lib.pathExists ./${hostName}/home.nix;

          specialArgs' = specialArgs // {
            inherit hostName;
          };
        in
        lib.nixosSystem {
          specialArgs = specialArgs';

          modules = [
            ./${hostName}
            {
              networking.hostName = hostName;
            }
          ]
          ++ [
            inputs.sops-nix.nixosModules.sops
            ({ pkgs, lib, ... }: {
              _module.args = {
                sopsSecretsFrom = file: secrets: lib.mapAttrs (_: secret: secret // { sopsFile = file; }) secrets;
              };

              sops.defaultSopsFile = ./${hostName}/secrets.yaml;
              sops.age.keyFile = "/var/lib/sops-nix/key.txt";
              environment.systemPackages = with pkgs; [ sops ];

              systemd.tmpfiles.rules = [
                "d /var/lib/sops-nix 0700 root root - -"
              ];
            })
          ]
          ++ (lib.optionals hasHome [
            ../modules/nixos/user
            inputs.hm.nixosModules.default
            ({ config, ... }: {
              home-manager.extraSpecialArgs = specialArgs' // { nixosConfig = config; };
              home-manager.useGlobalPkgs = true;
              home-manager.users.kat.imports = [ ./${hostName}/home.nix ];
            })
          ]);
        };

      hosts = lib.attrNames (lib.filterAttrs (path: type: type == "directory") (builtins.readDir ./.));
    in
    lib.genAttrs hosts nixosConfiguration;
}
