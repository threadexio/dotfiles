{ pkgs, ... }: {
  imports = [
    ../../gtk

    ../../programs/git
    ../../programs/gnome
    ../../programs/gpg
    ../../programs/ssh
    ../../programs/vscodium
    ../../programs/zsh
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
