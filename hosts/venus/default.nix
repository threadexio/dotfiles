# Edit this configuration fime to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{ pkgs, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../modules/core.nix
    ../modules/network.nix
    ../modules/security.nix
    ../modules/virtualisation.nix
    ../modules/containers.nix
    ../modules/gnome.nix
  ];

  boot.kernelParams = [ "net.ifnames=0" ];

  # Boot from external USB key
  boot.initrd.kernelModules = [ "uas" "usbcore" "usb_storage" "vfat" "nls_cp437" "nls_iso8859_1" ];
  boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
    mkdir -m 0755 -p /key
    sleep 5
    mount -n -t vfat -o ro /dev/disk/by-label/BOOTKEY /key
  '';

  boot.initrd.luks.devices."cryptroot" = {
    keyFile = "/key/venus.key";
    preLVM = false;
  };

  boot.initrd.luks.devices."cryptdata" = {
    keyFile = "/key/venus.hdd.key";
    preLVM = false;
  };

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/disk/by-id/ata-SanDisk_SDSSDA240G_172475459411";

  networking.hostName = "venus";
  system.stateVersion = "23.05";
}
