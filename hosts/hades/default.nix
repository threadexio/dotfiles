{ self
, inputs
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
    ../../modules/nixos/hardware/intel
    ../../modules/nixos/virt/kvm
    ../../modules/nixos/virt/podman
    ../../modules/nixos/custom
    ../../modules/nixos/builder
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

  services.minecraft-server = {
    enable = true;
    package = pkgs.fabricServers.fabric-1_21_4.withMods (
      { pkgs, version, ... }:
      [
        (pkgs.fetchurl {
          pname = "architectury";
          inherit version;
          url = "https://cdn.modrinth.com/data/lhGA9TYQ/versions/73nlw3WM/architectury-15.0.3-fabric.jar";
          hash = "sha256-nhH4HueGQBom3khql5hodVmlMp/sPNQV6U+jw5WDUvM=";
        })
        (pkgs.fetchurl {
          pname = "cloth-config";
          inherit version;
          url = "https://cdn.modrinth.com/data/9s6osm5g/versions/TJ6o2sr4/cloth-config-17.0.144-fabric.jar";
          hash = "sha256-H9oMSonU8HXlGz61VwpJEocGVtJS2AbqMJHSu8Bngeo=";
        })
        (pkgs.fetchurl {
          pname = "fabric-api";
          inherit version;
          url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/p96k10UR/fabric-api-0.119.4%2B1.21.4.jar";
          hash = "sha256-0YO6y4RRZ/CSZML5AyK37P/ogm3r2m9g5ZeIkmS+9K8=";
        })
        (pkgs.fetchurl {
          pname = "fabric-language-kotlin";
          inherit version;
          url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/Y91MRWtG/fabric-language-kotlin-1.13.5%2Bkotlin.2.2.10.jar";
          hash = "sha256-waj7tOTvanIRze9wQxeVpObUU/5XE/sSweYnnWSqrYQ=";
        })
        (pkgs.fetchurl {
          pname = "ferritecore";
          inherit version;
          url = "https://cdn.modrinth.com/data/uXXizFIs/versions/IPM0JlHd/ferritecore-7.1.1-fabric.jar";
          hash = "sha256-DdXpIDVSAk445zoPW0aoLrZvAxiyMonGhCsmhmMnSnk=";
        })
        (pkgs.fetchurl {
          pname = "lithium";
          inherit version;
          url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/u8pHPXJl/lithium-fabric-0.15.3%2Bmc1.21.4.jar";
          hash = "sha256-FTiR6NaYj+3/pQmIUacloTfD5coEqJqN9An+sxNiPrQ=";
        })
        (pkgs.fetchurl {
          pname = "RoughlyEnoughItems";
          inherit version;
          url = "https://cdn.modrinth.com/data/nfn13YXA/versions/C4edQN1w/RoughlyEnoughItems-18.0.808-fabric.jar";
          hash = "sha256-r+IkbTXwoaM+zuK3QISWcrJzqtb92ffGs1xjXJK2uXU=";
        })
        (pkgs.fetchurl {
          pname = "silk-all";
          inherit version;
          url = "https://cdn.modrinth.com/data/aTaCgKLW/versions/7WFi2tUG/silk-all-1.11.0.jar";
          hash = "sha256-bM+vZFYMPwXeWN5lPsNS1NsYbWbw1JXxawV+fJiKYGg=";
        })
        (pkgs.fetchurl {
          pname = "skinrestorer";
          inherit version;
          url = "https://cdn.modrinth.com/data/ghrZDhGW/versions/tAfs8lH0/skinrestorer-2.4.3%2B1.21-fabric.jar";
          hash = "sha256-TACR5KAOQWeA/D3xnK5S8aGXOVBVrcZZaQO7qulZkIo=";
        })
        (pkgs.fetchurl {
          pname = "syncmatica";
          inherit version;
          url = "https://cdn.modrinth.com/data/bfneejKo/versions/PpQoWWxV/syncmatica-fabric-1.21.4-0.3.14-sakura.4.jar";
          hash = "sha256-yfzaT9bJQz2FoMO9e0JlvKYRKcA2803RlQZsNFEeKu0=";
        })
        (pkgs.fetchurl {
          pname = "veinminer";
          inherit version;
          url = "https://cdn.modrinth.com/data/OhduvhIc/versions/VDHlG2JK/veinminer-fabric-2.4.2.jar";
          hash = "sha256-gNr71pHPAlupLQUxfEW0al1tTRo7qpesHreyy1bRk0I=";
        })
        (pkgs.fetchurl {
          pname = "worldedit";
          inherit version;
          url = "https://cdn.modrinth.com/data/1u6JkXh5/versions/bxlboAan/worldedit-mod-7.3.11.jar";
          hash = "sha256-V+8eKjmJ9N1o4AGTYVpvRV1mHUG2cD8Ghxo3P7S9FmU=";
        })
      ]
    );

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

  nixpkgs.overlays = [
    self.overlays.packages
    inputs.fabric-servers.overlays.default
  ];

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  networking.hostName = "hades";
  system.stateVersion = "24.05";
}
