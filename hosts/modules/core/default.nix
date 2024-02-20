{ pkgs, ... }: {
  imports = [
    ./locale.nix
    ./network.nix
    ./nix.nix
    ./security.nix
  ];

  boot.tmp.cleanOnBoot = true;

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
