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

  services.minecraft-server = {
    enable = true;
    package = pkgs.papermcServers.papermc-1_21_4;

    eula = true;
    jvmOpts = "-Xmx4096M -Xms2048M";
  };

  systemd.services.minecraft-server.serviceConfig.ExecStopPost = [
    "+${pkgs.btrfs-utils}/bin/btrfs-snapshot ${config.services.minecraft-server.dataDir}"
  ];

  systemd.services.watchpuppy = let
    misc = pkgs.callPackage ./watchpuppy-misc {};
  in {
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
