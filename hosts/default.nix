{ nixpkgs }: {
  redstarOS = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./redstarOS

      ../modules/core.nix
      ../modules/network.nix
      ../modules/security.nix
      ../modules/nvidia.nix
      ../modules/desktop.nix

      ../modules/development.nix
      ../modules/art.nix

      ../modules/virtualisation.nix
      ../modules/containers.nix
    ];
  };
}
