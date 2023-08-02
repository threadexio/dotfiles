{
  description = "My configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
      nixosConfigurations = import ./hosts { inherit nixpkgs; };
    };
}
