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
        let
          hasHome = lib.pathExists ./${host}/home.nix;
        in
        lib.nixosSystem {
          inherit specialArgs;

          modules = [
            ./${host}
          ]
          ++ (lib.optionals hasHome [
            ../modules/nixos/user
            inputs.hm.nixosModules.default
            {
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.useGlobalPkgs = true;
              home-manager.users.kat.imports = [ ./${host}/home.nix ];
            }
          ]);
        };

      hosts = lib.attrNames (lib.filterAttrs (path: type: type == "directory") (builtins.readDir ./.));
    in
    lib.genAttrs hosts nixosConfiguration;
}
