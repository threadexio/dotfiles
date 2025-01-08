{ self, inputs, ... }:
let
  homeConfiguration = { modules }:
  inputs.hm.lib.homeManagerConfiguration {
    extraSpecialArgs = { inherit self inputs; };
    pkgs = import inputs.nixpkgs {};

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
    };
  };
in
{
  _module.args = { inherit homeConfigurations; };

  flake.homeConfigurations = builtins.mapAttrs
    (_: homeConfiguration)
    homeConfigurations;
}
