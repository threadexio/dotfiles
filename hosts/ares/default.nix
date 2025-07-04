{ pkgs
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
  boot.kernelParams = [ "net.ifnames=0" "intel_iommu=on" "iommu=pt" "intel_pstate=disable" ];
  boot.kernelModules = [ "hp-wmi" ];
  boot.extraModprobeConfig = ''
    options snd_intel_dspcfg dsp_driver=1
  '';

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth = {
    enable = true;
    settings.General.Experimental = true;
  };

  services.hardware.bolt.enable = true;
  services.fwupd.enable = true;
  services.fstrim.enable = true;
  services.tailscale.useRoutingFeatures = "client";

  powerManagement.enable = lib.mkForce true;
  powerManagement.cpuFreqGovernor = "ondemand";
  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;

  services.flatpak.enable = true;
  hardware.ckb-next.enable = true;

  services.usbguard = {
    enable = true;
    rules = lib.readFile ./usbguard-rules.conf;
  };

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
