{ pkgs
, lib
, ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../modules/core
    ../modules/efi
    ../modules/hardware/intel
    ../modules/virt/kvm
    ../modules/virt/podman
  ];

  boot.plymouth.enable = lib.mkForce false;

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = false;

  services.hardware.bolt.enable = true;
  services.fstrim.enable = true;
  services.tailscale.useRoutingFeatures = "client";

  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "performance";

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
    ethtool
  ];

  networking.hostName = "hades";
  system.stateVersion = "24.05";
}
