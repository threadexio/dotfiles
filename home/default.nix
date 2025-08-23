{ inputs
, homes
, overlays
, specialArgs
, ...
}:

let
  inherit (inputs.nixpkgs) lib;

  homeConfiguration =
    { modules, system }:
    inputs.hm.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs { inherit system; };

      modules = [
        {
          nixpkgs.overlays = overlays;
          nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "discord" ];
        }
      ]
      ++ modules;

      extraSpecialArgs = specialArgs;
    };
in

{
  _module.args.homes = {
    ares = {
      modules = [ ./ares ];
      system = "x86_64-linux";
    };

    hades = {
      modules = [ ./hades ];
      system = "x86_64-linux";
    };

    hermes = {
      modules = [ ./hermes ];
      system = "aarch64-linux";
    };

    cerberus = {
      modules = [ ./cerberus ];
      system = "x86_64-linux";
    };
  };

  flake.homeConfigurations = builtins.mapAttrs (_: homeConfiguration) homes;
}
