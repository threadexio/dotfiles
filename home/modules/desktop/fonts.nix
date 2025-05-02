{ pkgs
, ...
}:

{
  home.packages = with pkgs; [
    cascadia-code
    inter
  ];

  fonts = {
    fontconfig = {
      enable = true;

      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        serif = [ "Noto Serif" ];
        sansSerif = [ "Inter" ];
        monospace = [ "Cascadia Code" ];
      };
    };
  };
}
