{ self
, inputs
, pkgs
, lib
, sopsSecretsFrom
, ...
}:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/core
    ../../modules/nixos/efi
    ../../modules/nixos/custom
    ../../modules/nixos/hardware/intel
    ../../modules/nixos/desktop/cosmic
    ../../modules/nixos/virt/kvm
    ../../modules/nixos/virt/podman
  ];

  custom.boot.luksUsbUnlock = {
    enable = true;
    devices."cryptroot" = {
      keyPath = "ares.key";
      usbDevice = "by-label/BOOTKEY";
    };
  };

  sops.secrets = {
    "ssh/ares".owner = "kat";
  } // (sopsSecretsFrom ../../secrets/common.yaml {
    "ssh/github".owner = "kat";
    "ssh/privategit".owner = "kat";
    "ssh/aws".owner = "kat";
  });

  boot.tmp.useTmpfs = true;
  boot.binfmt.preferStaticEmulators = true;
  boot.binfmt.emulatedSystems = [
    "armv7l-linux"
    "aarch64-linux"
    "riscv32-linux"
    "riscv64-linux"
  ];

  boot.kernelParams = [
    "net.ifnames=0"
    "intel_iommu=on"
    "iommu=pt"
  ];
  boot.kernelModules = [ "hp-wmi" ];

  services.hardware.bolt.enable = true;
  services.fwupd.enable = true;
  services.fstrim.enable = true;

  services.usbguard = {
    enable = true;
    rules = lib.readFile ./usbguard-rules.conf;
  };

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth = {
    enable = true;
    settings.General.Experimental = true;
  };

  powerManagement.enable = true;
  services.thermald.enable = true;

  services.openssh.enable = true;
  services.tailscale.enable = true;
  services.tailscale.extraUpFlags = [ "--accept-routes" ];
  services.tailscale.useRoutingFeatures = "client";

  services.flatpak.enable = true;
  hardware.ckb-next.enable = true;
  programs.ydotool.enable = true;
  programs.wireshark.enable = true;
  programs.adb.enable = true;

  users.users.kat.extraGroups = [
    "ydotool"
    "wireshark"
    "adbusers"
  ];

  environment.systemPackages = with pkgs; [
    wireshark-qt
    usbguard-utils
    btrfs-utils
  ];

  nixpkgs.overlays = [
    self.overlays.packages
    self.overlays.nixpkgs-manual
    inputs.rich-presence-wrapper.overlays.default
    inputs.rich-presence-wrapper.overlays.helix
    inputs.rich-presence-wrapper.overlays.zed-editor
  ];

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  networking.hostName = "ares";
  system.stateVersion = "24.05";
}
