{ config
, pkgs
, ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../modules/core
    ../modules/efi
    ../modules/hardware/intel
    ../modules/virt/kvm
    ../modules/virt/podman
    ../modules/custom
    ../modules/builder
  ];

  boot.tmp.useTmpfs = true;
  zramSwap.enable = true;
  zramSwap.algorithm = "zstd";

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = false;

  boot.blacklistedKernelModules = [ "nouveau" ];

  services.hardware.bolt.enable = true;
  services.fstrim.enable = true;
  services.tailscale.useRoutingFeatures = "client";

  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "performance";

  security.sudo.wheelNeedsPassword = false;

  users.users.kat.openssh.authorizedKeys.keyFiles = [
    ../../ssh/ares.pub
    ../../ssh/hermes.pub
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

  services.minecraft-server = {
    enable = true;
    package = pkgs.fabricServers.fabric-1_21_4;

    eula = true;
    jvmOpts = "-Xmx4096M -Xms2048M";
  };

  systemd.services.minecraft-server.serviceConfig.ExecStopPost = [
    "+${pkgs.btrfs-utils}/bin/btrfs-snapshot ${config.services.minecraft-server.dataDir}"
  ];

  systemd.services.watchpuppy =
    let
      misc = pkgs.callPackage ./watchpuppy-misc { };
    in
    {
      description = "Suspend on inactivity";
      after = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.watchpuppy}/bin/watchpuppy --check ${misc}/share/watchpuppy/check --every 120 --run ${misc}/share/watchpuppy/run --once";
        RemainAfterExit = false;
      };

      wantedBy = [ "multi-user.target" ];
    };

  environment.etc."systemd/system-sleep/watchpuppy" = {
    mode = "0755";
    source = pkgs.writeScript "watchpuppy-sleep-hook" ''
      #!${pkgs.runtimeShell}

      if [ "$1" = "post" ]; then
        ${pkgs.systemd}/bin/systemctl start minecraft-server.service
        ${pkgs.systemd}/bin/systemctl start watchpuppy.service
      fi
    '';
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

  networking.hostName = "hades";
  system.stateVersion = "24.05";
}
