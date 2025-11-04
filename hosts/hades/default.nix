{ self
, pkgs
, sopsSecretsFrom
, ...
}:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/core
    ../../modules/nixos/efi
    ../../modules/nixos/hardware/intel
    ../../modules/nixos/virt/kvm
    ../../modules/nixos/virt/podman
    ../../modules/nixos/custom
    ../../modules/nixos/builder

    ./services/minecraft
  ];

  sops.secrets = {
    "ssh/hades".owner = "kat";
  } // (sopsSecretsFrom ../../secrets/common.yaml {
    "ssh/privategit".owner = "kat";
    "ssh/github".owner = "kat";
  });

  boot.tmp.useTmpfs = true;
  zramSwap.enable = true;
  zramSwap.algorithm = "zstd";

  boot.binfmt.preferStaticEmulators = true;
  boot.binfmt.emulatedSystems = [
    "armv7l-linux"
    "aarch64-linux"
    "riscv32-linux"
    "riscv64-linux"
  ];

  boot.blacklistedKernelModules = [ "nouveau" ];

  services.hardware.bolt.enable = true;
  services.fstrim.enable = true;

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = false;

  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "performance";

  security.sudo.wheelNeedsPassword = false;

  services.openssh.enable = true;
  services.tailscale.enable = true;
  services.tailscale.extraUpFlags = [ "--accept-routes" ];
  services.tailscale.useRoutingFeatures = "client";
  users.users.kat.openssh.authorizedKeys.keyFiles = [
    ../../ssh/ares.pub
    ../../ssh/hermes.pub
    ../../ssh/cerberus.pub
  ];

  # sudo nft insert rule filter FORWARD position 0 ip daddr 10.0.0.0/24 meta iifname virbr0 reject with icmp type admin-prohibited
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

  networking.hostName = "hades";
  system.stateVersion = "24.05";
}
