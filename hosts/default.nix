{ nixpkgs, hm, overlays, homes, ... }:

let
  nixosSystem = { modules, home }:
    nixpkgs.lib.nixosSystem {
      modules = [
        hm.nixosModules.default
        {
          nixpkgs.overlays = overlays;
          home-manager.useGlobalPkgs = true;
          home-manager.users.kat.imports = home.modules;
        }
      ] ++ modules;
    };
in

rec {
  nixosSystems = {
    ares = {
      modules = [ ./ares ];
      home = homes."kat@ares";
    };

    venus = {
      modules = [ ./venus ];
      home = homes."kat@venus";
    };

    hades = {
      modules = [ ./hades ];
      home = homes."hades";
    };
  };

  nixosConfigurations = builtins.mapAttrs
    (_: nixosSystem)
    nixosSystems;
}
