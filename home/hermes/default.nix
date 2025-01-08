{ pkgs, ... }: {
  imports = [
    ../modules/programs/zsh
    ../modules/programs/tmux

    ../modules/programs/git
    ../modules/programs/gpg
    ../modules/programs/ssh

    ../modules/programs/helix
  ];

  home.packages = with pkgs; [
    # Man pages
    man-pages
    man-pages-posix

    ## C/C++
    gcc
    clang-tools

    ## Rust
    rustup

    ## Python
    python3

    # Debuggers & Profilers
    valgrind
    nmap # ncat
    dig

    ffmpeg
    imagemagick
  ];

  programs.home-manager.enable = true;
  programs.git.enable = true;

  home.username = "kat";
  home.homeDirectory = "/home/kat";
  home.stateVersion = "24.05";

  nix.package = pkgs.nix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
