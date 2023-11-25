{ pkgs, lib, ... }: {
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../modules/core.nix
      ../modules/efi.nix
      ../modules/network.nix
      ../modules/security.nix
      ../modules/nvidia.nix
      ../modules/virtualisation.nix
      ../modules/containers.nix

      #../modules/plasma.nix
      ../modules/gnome.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelParams = [ "net.ifnames=0" "intel_iommu=on" "iommu=pt" ];

    extraModprobeConfig = ''
      options kvm_intel nested=1
      options snd_hda_intel power_save=1
    '';
  };

  services.hardware.bolt.enable = true;
  services.fwupd.enable = true;
  security.tpm2.enable = true;

  powerManagement = {
    enable = lib.mkForce false;
    cpuFreqGovernor = "powersave";
  };

  services.flatpak.enable = true;
  hardware.ckb-next.enable = true;

  documentation = {
    man.enable = true;
    nixos.enable = true;
    dev.enable = true;
  };

  system.stateVersion = "23.05";
}
