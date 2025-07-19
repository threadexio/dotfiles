{ pkgs
, ...
}:

{
  fonts = {
    fontconfig = {
      enable = true;

      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        serif = [ "Noto Serif" ];
        sansSerif = [ "Inter" ];
        monospace = [ "CaskaydiaCove Nerd Font Mono" ];
      };
    };
  };

  home.packages = with pkgs; [
    libreoffice
    mpv

    inkscape
    gimp
    ffmpeg
    imagemagick

    inter
    nerd-fonts.caskaydia-cove
  ];
}
