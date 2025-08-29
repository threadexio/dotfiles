{ pkgs, ... }: {
  services.easyeffects.enable = true;

  xdg.configFile."easyeffects/input/mic.json".source = ./mic.json;
}
