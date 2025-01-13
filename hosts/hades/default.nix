{ self
, pkgs
, lib
, ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../modules/core
    ../modules/efi
    ../modules/hardware/intel
    ../modules/virt/kvm
    ../modules/virt/podman
  ];

  boot.plymouth.enable = lib.mkForce false;

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = false;

  services.hardware.bolt.enable = true;
  services.fwupd.enable = true;
  services.fstrim.enable = true;
  services.tailscale.useRoutingFeatures = "client";

  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "performance";

  networking.hostName = "hades";
  system.stateVersion = "24.05";
}
