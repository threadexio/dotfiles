{ self
, inputs
, homes
, ...
}:

let
  homeConfiguration = { modules, system }:
    inputs.hm.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs { inherit system; };

      modules = [
        { nixpkgs.overlays = [ self.overlays.packages ]; }
      ] ++ modules;

      extraSpecialArgs = { inherit self inputs; };
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
  };

  flake.homeConfigurations = builtins.mapAttrs
    (_: homeConfiguration)
    homes;
}
