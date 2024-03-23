{ ... }:
let
  hlib = import ../modules/lib;
  usbDevice = "/dev/disk/by-label/BOOTKEY";
in
{
  imports = [
    ./hardware-configuration.nix
    ../modules/core
    ../modules/hardware/nvidia
    ../modules/desktop/gnome
    ../modules/virt/kvm
    ../modules/virt/podman

    (hlib.unlockLuksWithUsbKey
      {
        luksDevice = "cryptroot";
        keyPath = "venus.key";
        inherit usbDevice;
      }
    )
    (hlib.unlockLuksWithUsbKey
      {
        luksDevice = "cryptdata";
        keyPath = "venus.hdd.key";
        inherit usbDevice;
      }
    )
  ];

  boot.kernelParams = [ "net.ifnames=0" ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/disk/by-id/ata-SanDisk_SDSSDA240G_172475459411";

  networking.hostName = "venus";
  system.stateVersion = "23.11";
}
