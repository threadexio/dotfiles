{ pkgs, lib, ... }:

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

  home.packages = with pkgs; [
    ffmpeg
    imagemagick
  ];

  nix.package = lib.mkDefault pkgs.nix;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings.substituters = lib.mkAfter [ "http://atlas:15000" ];

  nix.settings.builders-use-substitutes = true;
  nix.settings.builders = [
    "ssh-ng://kat@hades x86_64-linux,aarch64-linux - - - nixos-test,benchmark,big-parallel,kvm"
  ];
  nix.settings.trusted-public-keys = [ "hades:j8p0UaxcNZ2UamilDop0OUYpwIfY4zFJROdo2kKib9Y=" ];

  home.stateVersion = "24.05";
}
