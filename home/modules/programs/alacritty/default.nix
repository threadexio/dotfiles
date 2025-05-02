{ pkgs
, ...
}:

{
  programs.alacritty = {
    enable = true;

    settings =
      let
        fontFamily = "Cascadia Code";

        mkFontStyle = style: { family = fontFamily; inherit style; };
      in
      {
        general.live_config_reload = false;

        window = {
          padding = { x = 2; y = 2; };
          opacity = 0.5;
          blur = true;
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
    pkgs.nerd-fonts.caskaydia-cove
  ];
}
