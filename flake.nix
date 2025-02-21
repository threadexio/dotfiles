{
  description = "My configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    rich-presence-wrapper = {
      url = "github:threadexio/rich-presence-wrapper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./home
        ./hosts
        ./pkgs
      ];

      systems = [
        "x86_64-linux"
      ];

      perSystem =
        { pkgs, ... }:
        let
          formatterPkg = pkgs.nixpkgs-fmt;
        in
        {
          formatter = formatterPkg;

          devShells.default = pkgs.mkShell {
            packages = [ formatterPkg ];
          };
        };
    };
}
