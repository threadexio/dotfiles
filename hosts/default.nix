{ self, inputs, homeExports, ... }:
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
          home-manager.extraSpecialArgs = { inherit self inputs; };
        }
      ] ++ homeExport.system-modules;

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
