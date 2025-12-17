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

  # home-manager seems to create this file and then forget it exists and later
  # fails when it tries to re-create it.
  xdg.configFile."fontconfig/conf.d/10-hm-fonts.conf".force = true;

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
