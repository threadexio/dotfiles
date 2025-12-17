{
  description = "My configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";


    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur/caac68328a0d10c35dee1cc1a8acfd613e02f8a1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fabric-servers = {
      url = "github:threadexio/nixpkgs/fabric-servers-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rich-presence-wrapper.url = "github:threadexio/rich-presence-wrapper";
    wolly.url = "github:threadexio/wolly";
    rswd.url = "git+ssh://git@github.com/threadexio/rswd";
  };

  outputs =
    { self
    , nixpkgs
    , flake-parts
    , ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./hosts
        ./home
        ./pkgs
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        { pkgs, ... }:
        {
          formatter = pkgs.nixpkgs-fmt;
        };
    };
}
