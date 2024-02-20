{ inputs, homeModules, ... }: {
  flake.nixosConfigurations =
    let
      mkNixosSystem = { configurationPath, homeProfile, extraModules ? [ ], ... }:
        inputs.nixpkgs.lib.nixosSystem {
          modules = [
            configurationPath
            ./modules/users
            inputs.hm.nixosModules.default
            {
              home-manager.users.kat.imports = homeModules.${homeProfile};
              home-manager.useGlobalPkgs = true;
            }
          ] ++ extraModules;
        };
    in
    {
      ares = mkNixosSystem {
        configurationPath = ./ares;
        homeProfile = "kat@ares";
      };

      venus = mkNixosSystem {
        configurationPath = ./venus;
        homeProfile = "kat@venus";
      };
    };
}
