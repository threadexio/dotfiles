{ ... }:

{
  imports = [
    ../../modules/home/core

    ../../modules/home/programs/zsh
    ../../modules/home/programs/tmux
    ../../modules/home/programs/helix
    ../../modules/home/programs/ssh
  ];

  home.stateVersion = "25.11";
}
