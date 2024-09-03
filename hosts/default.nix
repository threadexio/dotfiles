{ self, inputs, homeModules, ... }:
let
  mkNixosSystem = { configuration, homeProfile }:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        ./modules/custom
        inputs.hm.nixosModules.default
        configuration

        {
          home-manager.users.kat.imports = homeModules."${homeProfile}";
          home-manager.useGlobalPkgs = true;
          home-manager.extraSpecialArgs = { inherit self inputs; };
        }
      ];

      specialArgs = { inherit self inputs; };
    };
in
{
  flake.nixosConfigurations = {
    ares = mkNixosSystem {
      configuration = ./ares;
      homeProfile = "kat@ares";
    };

    venus = mkNixosSystem {
      configuration = ./venus;
      homeProfile = "kat@venus";
    };
  };
}
