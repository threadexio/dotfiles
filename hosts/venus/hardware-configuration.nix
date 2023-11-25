# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ata_generic" "uhci_hcd" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/5bef0f15-1269-4861-9e5b-6d8a485d60ef";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/fee3daa7-d1cd-42f1-8232-8c7b6a26a4a2";

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/5bef0f15-1269-4861-9e5b-6d8a485d60ef";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-uuid/5bef0f15-1269-4861-9e5b-6d8a485d60ef";
      fsType = "btrfs";
      options = [ "subvol=@var_log" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/8d77a58f-51cd-49fa-b01d-7f093e4feab5";
      fsType = "ext4";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s25.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp16s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
