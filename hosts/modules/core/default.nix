{ config, pkgs, ... }: {
  imports = [
    ./locale.nix
    ./network.nix
    ./nix.nix
    ./security.nix
    ./user.nix
  ];

  boot.tmp.cleanOnBoot = true;

  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.emergencyAccess = config.users.users.kat.hashedPassword;

  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-122b.psf.gz";

  environment.systemPackages = with pkgs; [
    terminus_font

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
