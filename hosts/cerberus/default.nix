{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/core
    ../../modules/nixos/networking
    ../../modules/nixos/services/openssh
    ../../modules/nixos/virtualisation/podman
    ../../modules/nixos/builder/pool
  ];

  sops.secrets = {
    "ssh/cerberus".owner = "kat";
  };

  zramSwap.enable = true;
  boot.tmp.cleanOnBoot = true;

  services.tailscale.enable = true;
  services.tailscale.extraUpFlags = [ "--accept-routes" "--advertise-exit-node" ];
  services.tailscale.useRoutingFeatures = "both";

  users.users.kat.openssh.authorizedKeys.keyFiles = [
    ../../ssh/ares.pub
    ../../ssh/hermes.pub
  ];

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "25.11";
}
