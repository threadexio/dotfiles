{ config, pkgs, ... }: {
  imports = [
    ./locale.nix
    ./network.nix
    ./nix.nix
    ./security.nix
  ];

  boot.tmp.cleanOnBoot = true;

  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.emergencyAccess = config.users.users.kat.hashedPassword;

  environment.systemPackages = with pkgs; [
    util-linux
    usbutils
    pciutils
    moreutils
    vim
    curl
    htop
    file
  ];
}
