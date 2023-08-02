{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ffmpeg
    imagemagick
    krita
    inkscape
    gimp
    kdenlive
    obs-studio
  ];
}
