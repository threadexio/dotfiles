{ pkgs, ... }: {
  imports = [
    ../modules/core
    ../modules/programs/git
    ../modules/programs/gnome
    ../modules/programs/gpg
    ../modules/programs/ssh
    ../modules/programs/vscodium
    ../modules/programs/zsh
  ];

  home.packages = with pkgs; [
    firefox
    keepassxc
    libreoffice
    python3
    ffmpeg
    imagemagick
    krita
    inkscape
    gimp
    kdenlive
    obs-studio
  ];
}
