{ config
, pkgs
, lib
, ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../modules/core
    ../modules/efi
    ../modules/hardware/intel
    ../modules/desktop/plasma
    ../modules/virt/kvm
    ../modules/virt/podman
    ../modules/custom
  ];

  custom.boot.luksUsbUnlock = {
    enable = true;
    devices."cryptroot" = {
      keyPath = "ares.key";
      usbDevice = "by-label/BOOTKEY";
    };
  };

  boot.tmp.useTmpfs = true;
  zramSwap.enable = true;
  zramSwap.algorithm = "zstd";

  boot.binfmt.emulatedSystems = [
    "armv7l-linux" "aarch64-linux"
    "riscv32-linux" "riscv64-linux"
  ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  boot.kernelParams = [ "net.ifnames=0" "intel_iommu=on" "iommu=pt" ];
  boot.kernelModules = [ "hp-wmi" ];

  # Hardware
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth = {
    enable = true;
    settings.General.Experimental = true;
  };

  services.hardware.bolt.enable = true;
  services.fwupd.enable = true;
  services.fstrim.enable = true;

  services.usbguard = {
    enable = true;
    rules = lib.readFile ./usbguard-rules.conf;
  };

  # Power Management
  powerManagement.enable = lib.mkForce true;
  services.power-profiles-daemon.enable = lib.mkForce false;
  services.tlp = {
    enable = true;

    settings = {
      # Battery Care
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;

      # Kernel
      NMI_WATCHDOG = 0;

      # Processor
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };

  services.tailscale.useRoutingFeatures = "client";
  services.flatpak.enable = true;
  hardware.ckb-next.enable = true;
  programs.ydotool.enable = true;
  programs.wireshark.enable = true;
  programs.adb.enable = true;

  users.users.kat.extraGroups = [ "ydotool" "wireshark" "adbusers" ];

  environment.systemPackages = with pkgs; [
    wireshark-qt
    usbguard-utils
    btrfs-utils
  ];

  networking.hostName = "ares";
  system.stateVersion = "24.05";
}
