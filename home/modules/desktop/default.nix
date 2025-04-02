{ pkgs, ... }: {
  xdg.dataFile."wallpapers" = {
    recursive = true;
    source = "${pkgs.wallpapers}/share/wallpapers";
  };

  xdg.dataFile."backgrounds" = {
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
