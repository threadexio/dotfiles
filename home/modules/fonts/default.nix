{ pkgs, ... }: {
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
    inter
  ];

  fonts = {
    fontconfig = {
      enable = true;

      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        serif = [ "Noto Serif" ];
        sansSerif = [ "Inter" ];
        monospace = [ "CaskaydiaMono Nerd Font Mono" ];
      };
    };
  };
}
