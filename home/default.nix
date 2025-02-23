{ nixpkgs, hm, overlays, ... }:

let
  homeConfiguration = { modules, system ? null }:
    hm.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { inherit system overlays; };

      inherit modules;
    };
in

rec {
  homes = {
    "kat@ares" = {
      modules = [ ./ares ];
    };

    "kat@venus" = {
      modules = [ ./venus ];
    };

    "hermes" = {
      modules = [ ./hermes ];
      system = "aarch64-linux";
    };

    "hades" = {
      modules = [ ./hades ];
    };
  };

  homeConfigurations = builtins.mapAttrs
    (_: homeConfiguration)
    homes;
}
