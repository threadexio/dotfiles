{ pkgs, lib, ... }: {
  _module.args = {
    hostname = "hermes";
  };

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

  nix.package = lib.mkDefault pkgs.nix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.settings.substituters = lib.mkBefore [ "http://hades:5000" ];

  nix.settings.builders-use-substitutes = true;
  nix.settings.builders = [ "ssh-ng://kat@hades aarch64-linux" ];
  nix.settings.trusted-public-keys = [ "hades:j8p0UaxcNZ2UamilDop0OUYpwIfY4zFJROdo2kKib9Y=" ];

  home.stateVersion = "24.05";
}
