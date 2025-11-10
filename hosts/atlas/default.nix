{ ...
}:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/core
    ../../modules/nixos/virt/podman

    ./services/nginx
    ./services/gitea
    ./services/vaultwarden
    ./services/syncthing
    ./services/cloudflare

    ./services/vsftpd
    ./services/wolly
    ./services/rswd
  ];

  sops.secrets = {
    "ssh/atlas".owner = "kat";
  };

  _module.args = {
    btrfsDataMount = subvol: {
      device = "/dev/disk/by-label/data";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "discard=async"
        "noatime"
        "subvol=${subvol}"
      ];
    };
  };

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = false;
  networking.wireless.enable = false;

  services.openssh.enable = true;
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "server";
  users.users.kat.openssh.authorizedKeys.keyFiles = [
    ../../ssh/ares.pub
    ../../ssh/hermes.pub
  ];

  security.sudo.wheelNeedsPassword = false;

  networking.hostName = "atlas";
  system.stateVersion = "25.05";
}
