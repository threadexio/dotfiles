{
  description = "My configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    let
      users = import ./users { inherit inputs; };
    in
    {
      nixosConfigurations = import ./hosts { inherit inputs users; };
    };
}
