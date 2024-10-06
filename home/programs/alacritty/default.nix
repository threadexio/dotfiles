{ pkgs, ... }: {
  imports = [
    ../../fonts
  ];

  programs.alacritty = {
    enable = true;

    settings =
      let
        fontFamily = "CaskaydiaCove Nerd Font Mono";
      in
      {
        live_config_reload = false;

        window = {
          padding = { x = 5; y = 5; };
          opacity = 0.5;
          blur = true;
          dynamic_title = true;
        };

        font =
          let
            family = fontFamily;
          in
          {
            size = 12;

            normal = { inherit family; style = "Regular"; };
            bold = { inherit family; style = "Bold"; };
            italic = { inherit family; style = "Italic"; };
            bold_italic = { inherit family; style = "Bold Italic"; };
          };

        cursor = {
          thickness = 0.1;
        };
      };
  };
}
