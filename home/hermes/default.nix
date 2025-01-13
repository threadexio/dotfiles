{ pkgs, ... }: {
  imports = [
    ../modules/core

    ../modules/programs/zsh
    ../modules/programs/tmux
    ../modules/programs/git
    ../modules/programs/gpg
    ../modules/programs/ssh
    ../modules/programs/helix

    ../modules/dev/common
    ../modules/dev/c
    ../modules/dev/rust
    ../modules/dev/python
  ];

  home.packages = with pkgs; [
    ffmpeg
    imagemagick
  ];

  home.stateVersion = "24.05";
}
