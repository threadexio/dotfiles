{ lib
, ...
}:

{
  imports = [
    ../../modules/home/core
    ../../modules/home/programs/zsh
    ../../modules/home/programs/tmux
    ../../modules/home/programs/helix
    ../../modules/home/dev/common
  ];

  home.stateVersion = lib.trivial.release;
}
