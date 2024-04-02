{ lib, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../modules/core
    ../modules/hardware/nvidia
    ../modules/desktop/gnome
    ../modules/virt/kvm
    ../modules/virt/podman
  ];

  custom.boot.luksUsbUnlock = {
    enable = true;
    usbDevice = "/dev/disk/by-label/BOOTKEY";
    devices = {
      "cryptroot".keyPath = "venus.key";
      "cryptdata".keyPath = "venus.hdd.key";
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
