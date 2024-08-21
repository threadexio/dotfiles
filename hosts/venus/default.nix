{ lib, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../modules/core
    ../modules/hardware/nvidia
    ../modules/desktop/gnome
    ../modules/virt/kvm
    ../modules/virt/podman
  ];

  custom.boot.luksUsbUnlock =
    let
      usbDevice = "/dev/disk/by-label/BOOTKEY";
    in
    {
      enable = true;
      devices = {
        "cryptroot" = {
          keyPath = "venus.key";
          inherit usbDevice;
        };

        "cryptdata" = {
          keyPath = "venus.hdd.key";
          inherit usbDevice;
        };
      };
    };

  boot.initrd.luks.devices = {
    "cryptroot".preLVM = false;
    "cryptdata".preLVM = false;
  };

  boot.kernelParams = [ "net.ifnames=0" ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/disk/by-id/ata-SanDisk_SDSSDA240G_172475459411";

  swapDevices = [
    { device = "/swap/main"; }
  ];

  services.xserver.videoDrivers = lib.mkForce [ "nvidiaLegacy340" ];

  networking.hostName = "venus";
  system.stateVersion = "23.11";
}
