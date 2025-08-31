{ pkgs
, ...
}:

{
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
