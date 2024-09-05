{ config
, lib
, modulesPath
, ...
}:
let
  rootDevice = "/dev/disk/by-label/ROOT";
  btrfsMountOpts = [ "compress=zstd" "discard=async" "noatime" ];
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-label/CRYPTROOT";

  fileSystems."/" =
    { device = rootDevice;
      fsType = "btrfs";
      options = btrfsMountOpts ++ [ "subvol=@" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = rootDevice;
      fsType = "btrfs";
      options = btrfsMountOpts ++ [ "subvol=@home" ];
    };

  fileSystems."/nix" =
    { device = rootDevice;
      fsType = "btrfs";
      options = btrfsMountOpts ++ [ "subvol=@nix" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp58s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
