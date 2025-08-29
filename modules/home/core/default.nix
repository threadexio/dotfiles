{ config, ... }: {
  home.username = "kat";
  home.homeDirectory = "/home/kat";

  programs.home-manager.enable = true;
  programs.git.enable = true;

  home.sessionPath = [
    "${config.home.homeDirectory}/.bin"
  ];

  systemd.user.startServices = "sd-switch";
}
