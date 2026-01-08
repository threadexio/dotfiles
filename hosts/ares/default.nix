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
    inputs.nixos-hardware.nixosModules.hp-elitebook-830g6

    ../../modules/nixos/core
    ../../modules/nixos/efi
    ../../modules/nixos/networking
    ../../modules/nixos/services/openssh
    ../../modules/nixos/custom
    ../../modules/nixos/desktop/cosmic
    ../../modules/nixos/virtualisation/kvm
    ../../modules/nixos/virtualisation/podman
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
  boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];
  boot.binfmt.preferStaticEmulators = true;
  boot.binfmt.emulatedSystems = [
    "armv7l-linux"
    "aarch64-linux"
    "riscv32-linux"
    "riscv64-linux"
  ];

  services.usbguard = {
    enable = true;
    rules = lib.readFile ./usbguard-rules.conf;
  };

  hardware.bluetooth = {
    enable = true;
    settings.General.Experimental = true;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ intel-media-driver ];
  };
  

  services.system76-scheduler.enable = true;
  services.tailscale.enable = true;
  services.tailscale.extraUpFlags = [ "--accept-routes" ];
  services.tailscale.useRoutingFeatures = "client";
  networking.firewall.enable = false;

  services.flatpak.enable = true;
  hardware.ckb-next.enable = true;
  hardware.ckb-next.package = lib.warn "Using temporary a patch for ckb-next due to https://github.com/NixOS/nixpkgs/issues/444209." (pkgs.ckb-next.overrideAttrs (old: {
    cmakeFlags = (old.cmakeFlags or [ ]) ++ [ "-DUSE_DBUS_MENU=0" ];
  }));
  programs.ydotool.enable = true;
  programs.wireshark.enable = true;
  programs.adb.enable = true;

  users.users.kat.extraGroups = [
    "ydotool"
    "adbusers"
  ];

  environment.systemPackages = with pkgs; [
    wireshark-qt
    usbguard-utils
    btrfs-utils
  ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

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

  system.stateVersion = "24.05";
}
