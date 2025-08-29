{ ... }:

{
  imports = [
    ../../modules/home/core

    ../../modules/home/programs/zsh
    ../../modules/home/programs/tmux
    ../../modules/home/programs/git
    ../../modules/home/programs/gpg
    ../../modules/home/programs/ssh
    ../../modules/home/programs/helix

    ../../modules/home/dev/common
    ../../modules/home/dev/c
    ../../modules/home/dev/rust
    ../../modules/home/dev/python
  ];

  home.stateVersion = "24.05";
}
