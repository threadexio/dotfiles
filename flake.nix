{
  description = "My configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    rich-presence-wrapper = {
      url = "github:threadexio/rich-presence-wrapper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, flake-utils, ... }@inputs:
    let
      mkFlakePackages = import ./pkgs;

      perSystem = flake-utils.lib.eachDefaultSystem (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          formatter = pkgs.nixpkgs-fmt;
          packages = mkFlakePackages pkgs;
        });

      inputs' = inputs // {
        overlays = [
          (final: _: rec {
            rich-presence-wrapper = inputs.rich-presence-wrapper.packages.${final.system}.default.override {
              programs = [ "helix" ];
            };

            helix = rich-presence-wrapper;
          })

          (final: _: mkFlakePackages final)
        ];
      };

      home = import ./home inputs';

      inputs'' = inputs' // { inherit (home) homes; };

      hosts = import ./hosts inputs'';

      flake = {
        inherit (home) homeConfigurations;
        inherit (hosts) nixosConfigurations;
      };
    in
    flake // perSystem;
}
