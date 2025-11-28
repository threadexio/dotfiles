{ lib
, ...
}:

{
  imports = [
    ../../modules/nixos/core
    ../../modules/nixos/efi
    ../../modules/nixos/networking
    ../../modules/nixos/services/openssh
  ];

  security.sudo.wheelNeedsPassword = false;
  services.getty.autologinUser = "kat";

  services.openssh.hostKeys = lib.mkForce [
    {
      type = "ed25519";
      path = "/etc/ssh/host_ed25519_key";
    }
  ];

  nixpkgs.hostPlatform = builtins.currentSystem or "x86_64-linux";
  system.stateVersion = lib.trivial.release;
}
