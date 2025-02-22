{ self, inputs, homeConfigurations, overlays, ... }:
let
  lib = inputs.nixpkgs.lib;

  nixosSystem =
    { modules, homeConfigurations }:
    let
      specialArgs = { inherit self inputs; };

      homeModules = lib.flatten (map
        ({ modules }: {
          home-manager.users.kat.nixpkgs.overlays = overlays;
          home-manager.users.kat.imports = modules;
        })
        homeConfigurations
      );
    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit specialArgs;

      modules = [
        inputs.hm.nixosModules.default
        {
          nixpkgs.overlays = overlays;
          home-manager.useGlobalPkgs = true;
          home-manager.extraSpecialArgs = specialArgs;
        }

        ./modules/custom # TODO: remove
      ] ++ modules ++ homeModules;
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

    hades = {
      modules = [ ./hades ];
      homeConfigurations = [
        homeConfigurations."hades"
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
