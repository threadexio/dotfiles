{ config
, lib
, pkgs
, modulesPath
, ...
}:
let
  rootDevice = "/dev/disk/by-label/ROOT";
  btrfsMountOpts = [ "compress=zstd" "discard=async" "noatime" ];

  btrfsSubvolFs = subvol:
    {
      device = rootDevice;
      fsType = "btrfs";
      options = btrfsMountOpts ++ [ "subvol=${subvol}" ];
    };
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = btrfsSubvolFs "@";
  fileSystems."/home" = btrfsSubvolFs "@home";
  fileSystems."/nix" = btrfsSubvolFs "@nix";
  fileSystems."/var/log" = btrfsSubvolFs "@var_log";
  fileSystems."/.snapshots" = btrfsSubvolFs "@snapshots";

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [ "noatime" ];
    };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
