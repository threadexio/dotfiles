{ inputs, ... }:
let
  mkHomeConfiguration = { modules, system }: inputs.hm.lib.homeManagerConfiguration {
    inherit modules;
    pkgs = inputs.nixpkgs.legacyPackages.${system};
  };

  homeModules = {
    "kat@ares" = [ ../. ./ares ];
    "kat@venus" = [ ../. ./venus ];
  };
in
{
  _module.args = { inherit homeModules; };

  flake.homeConfigurations = {
    "kat@ares" = mkHomeConfiguration {
      modules = homeModules."kat@ares";
      system = "x86_64-linux";
    };

    "kat@venus" = mkHomeConfiguration {
      modules = homeModules."kat@venus";
      system = "x86_64-linux";
    };
  };
}
