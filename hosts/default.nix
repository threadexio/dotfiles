{ inputs, homeModules, ... }: {
  flake.nixosConfigurations = let
    mkNixosSystem = { configurationPath, homeProfile, extraModules ? [], ... }:
      inputs.nixpkgs.lib.nixosSystem {
        modules = [
          configurationPath
          ./modules/users.nix
          inputs.hm.nixosModules.default
          {
            home-manager.users.kat.imports = homeModules.${homeProfile};
            home-manager.useGlobalPkgs = true;
          }
        ] ++ extraModules;
      };
  in rec {
    ares = mkNixosSystem {
      configurationPath = ./ares;
      homeProfile = "kat@ares";
    };

    nixos = ares;

    venus = mkNixosSystem {
      configurationPath = ./venus;
      homeProfile = "kat@venus";
    };
  };
}
