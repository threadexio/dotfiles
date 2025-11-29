{ lib
, ...
}:

{
  imports = [
    ../../modules/nixos/core
    ../../modules/nixos/efi
    ../../modules/nixos/networking
  ];

  security.sudo.wheelNeedsPassword = false;
  services.getty.autologinUser = "kat";
  services.openssh.enable = true;

  nixpkgs.hostPlatform = builtins.currentSystem or "x86_64-linux";
  system.stateVersion = lib.trivial.release;
}
