{ self, inputs, ... }:
let
  homeConfiguration = { modules, system ? null }@args:
    inputs.hm.lib.homeManagerConfiguration {
      extraSpecialArgs = { inherit self inputs; };
      pkgs = import inputs.nixpkgs { inherit system; };

      inherit modules;
    };

  homeConfigurations = {
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
in
{
  _module.args = { inherit homeConfigurations; };

  flake.homeConfigurations = builtins.mapAttrs
    (_: homeConfiguration)
    homeConfigurations;
}
