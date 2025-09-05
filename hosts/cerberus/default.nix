{ self
, inputs
, pkgs
, lib
, ...
}:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/core
    ../../modules/nixos/virt/podman    
  ];

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

  # TODO: remove
  users.users.root.openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5zcR1AsHP9CL2g5GTcUYAO0PGXiwlqcPwpjY8wRor7 kat@ares'' ];

  nix.settings.substituters = lib.mkAfter [ "http://atlas:15000" ];
  nix.settings.builders-use-substitutes = true;
  nix.settings.builders = [
    "ssh-ng://kat@hades x86_64-linux,aarch64-linux - - - nixos-test,benchmark,big-parallel,kvm"
  ];
  nix.settings.trusted-public-keys = [ "hades:j8p0UaxcNZ2UamilDop0OUYpwIfY4zFJROdo2kKib9Y=" ];

  networking.hostName = "cerberus";
  system.stateVersion = "25.11";
}
