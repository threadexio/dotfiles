{ self
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
  ];

  custom.boot.luksUsbUnlock = {
    enable = true;
    devices."cryptroot" = {
      keyPath = "ares.key";
      usbDevice = "by-label/BOOTKEY";
    };
  };

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  boot.kernelParams = [ "net.ifnames=0" "intel_iommu=on" "iommu=pt" "intel_pstate=disable" ];
  boot.kernelModules = [ "hp-wmi" ];
  boot.extraModprobeConfig = ''
    options snd_intel_dspcfg dsp_driver=1
  '';

  fileSystems."/".options = [ "noatime" ];
  fileSystems."/boot".options = [ "noatime" ];

  fileSystems."/home/kat/build" = {
    fsType = "tmpfs";
    options = [ "size=10g" "mode=700" "huge=always" "uid=kat" "gid=users" ];
  };

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth = {
    enable = true;
    settings.General.Experimental = true;
  };

  services.hardware.bolt.enable = true;
  services.fwupd.enable = true;
  services.fstrim.enable = true;

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

  users.users.kat.extraGroups = [ "ydotool" "wireshark" ];

  environment.systemPackages = with pkgs; [
    wireshark-qt
    self.packages.${pkgs.system}.usbguard-utils
  ];

  documentation = {
    man.enable = true;
    nixos.enable = true;
    dev.enable = true;
  };

  networking.hostName = "ares";
    system.stateVersion = "24.05";
}
