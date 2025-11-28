{ self
, config
, pkgs
, sopsSecretsFrom
, ...
}:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/core
    ../../modules/nixos/efi
    ../../modules/nixos/networking
    ../../modules/nixos/custom
    ../../modules/nixos/services/openssh
    ../../modules/nixos/virtualisation/kvm
    ../../modules/nixos/virtualisation/podman
    ../../modules/nixos/builder/setup

    ./services/minecraft
  ];

  sops.secrets = {
    "ssh/hades".owner = "kat";
    "nix/cache_key" = {};
  } // (sopsSecretsFrom ../../secrets/common.yaml {
    "ssh/privategit".owner = "kat";
    "ssh/github".owner = "kat";
  });


  zramSwap.enable = true;
  zramSwap.algorithm = "zstd";
  boot.tmp.useTmpfs = true;
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.binfmt.preferStaticEmulators = true;
  boot.binfmt.emulatedSystems = [
    "armv7l-linux"
    "aarch64-linux"
    "riscv32-linux"
    "riscv64-linux"
  ];

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = false;

  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "performance";

  security.sudo.wheelNeedsPassword = false;

  services.tailscale.enable = true;
  services.tailscale.extraUpFlags = [ "--accept-routes" ];
  services.tailscale.useRoutingFeatures = "client";

  users.users.kat.openssh.authorizedKeys.keyFiles = [
    ../../ssh/ares.pub
    ../../ssh/hermes.pub
    ../../ssh/cerberus.pub
  ];

  networking.nftables.ruleset = ''
    table ip filter {
      # Restrict the VMs in `virbr1` from accessing devices on the local network
      # of the host. Is this 100% safe? Probably not...
      chain virbr1-local-firewall {
        type filter hook prerouting priority dstnat; policy accept;

        # Only allow packets of established connections to pass. This is needed
        # so you can initiate connections to the VMs from outside their network
        # and get a reply back.
        meta iifname virbr1 ip daddr 10.0.0.0/24 ct state { established, related } accept

        # Reject all other packets. This means that VMs are not able to initiate
        # connections to the host's local network. This also rejects any
        # connection-less protocols, like UDP.
        meta iifname virbr1 ip daddr 10.0.0.0/24 reject with icmp admin-prohibited
      }
    }
  '';

  services.sleep-on-inactivity = {
    enable = true;
    poll = "*-*-* *:0/10:00";
    check.tcp.enable = true;
  };

  systemd.services.wol = {
    description = "Wake-On-LAN";
    requires = [ "network.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.ethtool}/bin/ethtool -s enp2s0 wol g";
      Type = "oneshot";
      RemainAfterExit = true;
    };

    wantedBy = [ "multi-user.target" ];
  };

  builder.cache.keyPath = config.sops.secrets."nix/cache_key".path;

  environment.systemPackages = with pkgs; [
    btrfs-utils
    ethtool
  ];

  nixpkgs.overlays = [
    self.overlays.packages
  ];

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  system.stateVersion = "24.05";
}
