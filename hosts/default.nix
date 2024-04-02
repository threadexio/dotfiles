{ inputs, homeExports, ... }: {
  flake.nixosConfigurations =
    let
      mkNixosSystem = { configuration, homeProfile }:
        let
          homeExport = homeExports.${homeProfile};
        in
        inputs.nixpkgs.lib.nixosSystem {
          modules = [
            ./modules/custom
            inputs.hm.nixosModules.default
            configuration

            {
              home-manager.users.kat.imports = homeExport.hm-modules;
              home-manager.useGlobalPkgs = true;
            }
          ] ++ homeExport.system-modules;
        };
    in
    {
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
