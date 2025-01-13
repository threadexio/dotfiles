{ ... }: {
  imports = [
    ../modules/core

    ../modules/programs/git
    ../modules/programs/gnome
    ../modules/programs/gpg
    ../modules/programs/ssh
    ../modules/programs/zsh
    ../modules/programs/helix

    ../modules/dev/python
  ];

  home.stateVersion = "24.05";
}
