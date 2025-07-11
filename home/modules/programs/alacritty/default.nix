{ pkgs
, ...
}:

{
  programs.alacritty = {
    enable = true;

    settings =
      let
        fontFamily = "Comic Mono";

        mkFontStyle = style: { family = fontFamily; inherit style; };
      in
      {
        general.live_config_reload = false;

        window = {
          opacity = 0.90;
          blur = false;
          dynamic_title = true;
        };

        font = {
          size = 12;

          normal = mkFontStyle "Regular";
          bold = mkFontStyle "Bold";
          italic = mkFontStyle "Italic";
          bold_italic = mkFontStyle "Bold Italic";
        };

        cursor.thickness = 0.1;
      };
  };

  home.packages = [
    pkgs.comic-mono
  ];
}
