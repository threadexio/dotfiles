{ config, pkgs, lib, ... }: {
  home.username = "kat";
  home.homeDirectory = "/home/kat";

  programs.home-manager.enable = true;
  programs.git.enable = true;

  home.sessionPath = [
    "${config.home.homeDirectory}/.bin"
  ];

  nix.package = lib.mkDefault pkgs.nix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  systemd.user.startServices = "sd-switch";
}
