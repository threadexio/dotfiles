{ pkgs, ... }: {
  _module.args = {
    hostname = "ares";
  };

  imports = [
    ../modules/core
    ../modules/desktop/plasma

    ../modules/programs/zsh
    ../modules/programs/tmux
    ../modules/programs/git
    ../modules/programs/gpg
    ../modules/programs/ssh
    ../modules/programs/helix

    ../modules/programs/kitty
    ../modules/programs/alacritty
    ../modules/programs/zed
    ../modules/programs/chromium

    ../modules/dev/common
    ../modules/dev/c
    ../modules/dev/rust
    ../modules/dev/python

    ../modules/programs/easyeffects
    ../modules/services/syncthing
  ];

  home.packages = with pkgs; [
    discord
    wol
    hackvm
  ];

  home.stateVersion = "24.05";
}
