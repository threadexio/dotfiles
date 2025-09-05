{ pkgs
, lib
, ...
}:

{
  imports = [
    ../../modules/home/core

    ../../modules/home/programs/zsh
    ../../modules/home/programs/tmux
    ../../modules/home/programs/helix
  ];

  home.stateVersion = "25.11";
}
