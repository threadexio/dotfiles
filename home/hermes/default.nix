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

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
  programs.git.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
