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
        host:
        lib.nixosSystem {
          inherit specialArgs;

          modules = [
            inputs.hm.nixosModules.default

            {
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.useGlobalPkgs = true;
            }
            ./${host}
            {
              home-manager.users.kat.imports = [ ./${host}/home.nix ];
            }
          ];
        };

      hosts = lib.attrNames (lib.filterAttrs (path: type: type == "directory") (builtins.readDir ./.));
    in
    lib.genAttrs hosts nixosConfiguration;
}
