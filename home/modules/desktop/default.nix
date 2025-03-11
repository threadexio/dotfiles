{ pkgs, ... }: {
  xdg.dataFile."wallpapers" = {
    recursive = true;
    source = "${pkgs.wallpapers}/share/wallpapers";
  };

  home.packages = with pkgs; [
    keepassxc
    libreoffice
    mpv

    inkscape
    gimp
    ffmpeg
    imagemagick

    wallpapers
  ];
}
