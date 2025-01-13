{ pkgs, ... }: {
  home.packages = with pkgs; [
    keepassxc
    libreoffice
    mpv
    
    inkscape
    gimp
    ffmpeg
    imagemagick
  ];
}
