{ pkgs
, ...
}:

{
  programs.ghostty = {
    enable = true;

    settings = {
      auto-update = "off";

      theme = "vesper-custom";

      font-family = "Comic Mono";
      font-size = 12;

      cursor-style = "block";
      cursor-style-blink = "false";
      shell-integration-features = "no-cursor";

      window-padding-x = 2;
      window-padding-y = 1;
      unfocused-split-opacity = 0.5;

      keybind = [
        "global:cmd+t=toggle_quick_terminal"
      ];

      quick-terminal-size = "30%, 90%";
    };

    themes = {
      "vesper-custom" = {
        background = "101010";
        foreground = "a0a0a0";
        cursor-color = "ffd680";
        cursor-text = "101010";
        selection-background = "ffedcc";
        selection-foreground = "50412d";
        palette = [
          "0=101010"
          "1=ffb3b3"
          "2=ccffe6"
          "3=ffd680"
          "4=ffd680"
          "5=e6d6ff"
          "6=ffd680"
          "7=a0a0a0"
          "8=7e7e7e"
          "9=ffb3b3"
          "10=ccffe6"
          "11=ffd680"
          "12=ffd680"
          "13=e6d6ff"
          "14=ffd680"
          "15=ffffff"
        ];
      };
    };
  };

  home.packages = with pkgs; [
    comic-mono
  ];
}
