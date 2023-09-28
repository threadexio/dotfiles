{ pkgs, ... }: {
  home = {
    username = "kat";
    stateVersion = "23.05";
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;

  systemd.user.startServices = "sd-switch";
}