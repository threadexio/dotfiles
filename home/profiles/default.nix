{ inputs, ... }:
let
  mkHomeConfiguration = { modules, system }: inputs.hm.lib.homeManagerConfiguration {
    inherit modules;
    pkgs = inputs.nixpkgs.legacyPackages.${system};
  };

  homeExports = {
    "kat@ares" = {
      system-modules = [ ../system.nix ./ares/system.nix ];
      hm-modules = [ ../. ./ares ];
    };
    "kat@venus" = {
      system-modules = [ ../system.nix ];
      hm-modules = [ ../. ./venus ];
    };
  };
in
{
  _module.args = { inherit homeExports; };

  flake.homeConfigurations = {
    "kat@ares" = mkHomeConfiguration {
      modules = homeExports."kat@ares";
      system = "x86_64-linux";
    };

    "kat@venus" = mkHomeConfiguration {
      modules = homeExports."kat@venus";
      system = "x86_64-linux";
    };
  };
}
