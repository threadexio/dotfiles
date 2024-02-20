{ ... }: {
  home.username = "kat";
  home.homeDirectory = "/home/kat";
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
  programs.git.enable = true;

  systemd.user.startServices = "sd-switch";
}
