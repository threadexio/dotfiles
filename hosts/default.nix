{ self, inputs, homeConfigurations, ... }:
let
  lib = inputs.nixpkgs.lib;

  nixosSystem =
    { modules
    , homeConfigurations
    ,
    }:
    let
      specialArgs = { inherit self inputs; };
    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit specialArgs;

      modules = [
        inputs.hm.nixosModules.default
        {
          home-manager.useGlobalPkgs = true;
          home-manager.extraSpecialArgs = specialArgs;
        }

        ./modules/custom # TODO: remove
      ]
      ++ modules
      ++ (lib.flatten (map
        ({ modules }: {
          home-manager.users.kat.imports = modules;
        })
        homeConfigurations));
    };

  nixosSystems = {
    ares = {
      modules = [ ./ares ];
      homeConfigurations = [
        homeConfigurations."kat@ares"
      ];
    };

    venus = {
      modules = [ ./venus ];
      homeConfigurations = [
        homeConfigurations."kat@venus"
      ];
    };
  };
in
{
  _module.args = { inherit nixosSystems; };

  flake.nixosConfigurations = builtins.mapAttrs
    (_: nixosSystem)
    nixosSystems;
}
