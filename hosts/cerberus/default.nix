{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/core
    ../../modules/nixos/virt/podman

    ../../modules/nixos/builder/hades
  ];

  sops.secrets = {
    "ssh/cerberus".owner = "kat";
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  services.openssh.enable = true;
  services.tailscale.enable = true;
  services.tailscale.extraUpFlags = [ "--accept-routes" "--advertise-exit-node" ];
  services.tailscale.useRoutingFeatures = "both";
  users.users.kat.openssh.authorizedKeys.keyFiles = [
    ../../ssh/ares.pub
    ../../ssh/hermes.pub
  ];

  security.sudo.wheelNeedsPassword = false;

  networking.hostName = "cerberus";
  system.stateVersion = "25.11";
}
