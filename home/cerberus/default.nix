{ pkgs
, lib
, ...
}:

{
  imports = [
    ../modules/core

    ../modules/programs/zsh
    ../modules/programs/tmux
    ../modules/programs/git
    ../modules/programs/gpg
    ../modules/programs/helix

    ../modules/dev/common
    ../modules/dev/c
    ../modules/dev/python
  ];

  nix.package = lib.mkDefault pkgs.nix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  home.stateVersion = "25.11";
}
