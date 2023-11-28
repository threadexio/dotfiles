{ pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../modules/core.nix
      ../modules/efi.nix
      ../modules/network.nix
      ../modules/security.nix
      ../modules/virtualisation.nix
      ../modules/containers.nix
      ../modules/gnome.nix
    ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  boot.kernelParams = [ "net.ifnames=0" "intel_iommu=on" "iommu=pt" ];

  fileSystems."/".options = [ "noatime" ];
  fileSystems."/boot".options = [ "noatime" ];

  services.hardware.bolt.enable = true;
  services.fwupd.enable = true;

  powerManagement.enable = lib.mkForce true;
  powerManagement.cpuFreqGovernor = "ondemand";

  services.flatpak.enable = true;
  hardware.ckb-next.enable = true;

  documentation = {
    man.enable = true;
    nixos.enable = true;
    dev.enable = true;
  };

  system.stateVersion = "23.05";
}

