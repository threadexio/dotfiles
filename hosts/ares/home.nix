{ pkgs
, ...
}:

{
  imports = [
    ../../modules/home/core
    ../../modules/home/desktop/plasma

    ../../modules/home/programs/zsh
    ../../modules/home/programs/tmux
    ../../modules/home/programs/git
    ../../modules/home/programs/gpg
    ../../modules/home/programs/ssh
    ../../modules/home/programs/helix

    ../../modules/home/programs/kitty
    ../../modules/home/programs/alacritty
    ../../modules/home/programs/zed
    ../../modules/home/programs/chromium
    ../../modules/home/programs/discord

    ../../modules/home/dev/common
    ../../modules/home/dev/c
    ../../modules/home/dev/rust
    ../../modules/home/dev/python

    ../../modules/home/programs/easyeffects
    ../../modules/home/services/syncthing
  ];

  home.packages = with pkgs; [
    wol
    hackvm
    distrobox
  ];

  home.stateVersion = "24.05";
}
