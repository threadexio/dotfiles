{ pkgs
, lib
, ...
}:
let
  hlib = import ../modules/lib;
in
{
  imports = [
    ./hardware-configuration.nix

    ../modules/core
    ../modules/efi
    ../modules/hardware/intel
    ../modules/desktop/gnome
    ../modules/virt/kvm
    ../modules/virt/podman

    (hlib.unlockLuksWithUsbKey {
      devices."cryptroot".keyPath = "ares.key";
      usbDevice = "/dev/disk/by-label/BOOTKEY";
    })

    (hlib.mountTmpfs {
      path = "/home/kat/.cache";
      size = "16g";
      owner = "kat";
      group = "users";
    })
  ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  boot.kernelParams = [ "net.ifnames=0" "intel_iommu=on" "iommu=pt" ];

  fileSystems."/".options = [ "noatime" ];
  fileSystems."/boot".options = [ "noatime" ];

  services.hardware.bolt.enable = true;
  services.fwupd.enable = true;

  powerManagement.enable = lib.mkForce true;
  powerManagement.cpuFreqGovernor = "ondemand";

  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
    };
  };

  services.flatpak.enable = true;
  hardware.ckb-next.enable = true;

  services.usbguard = {
    enable = true;
    rules = lib.readFile ./usbguard-rules.conf;
  };

  documentation = {
    man.enable = true;
    nixos.enable = true;
    dev.enable = true;
  };

  networking.hostName = "ares";
  system.stateVersion = "23.11";
}
