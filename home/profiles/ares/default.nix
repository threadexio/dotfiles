{ pkgs, ... }: {
  imports = [
    ../../plasma

    ../../programs/git
    ../../programs/gpg
    ../../programs/ssh
    ../../programs/vscodium
    ../../programs/zed
    ../../programs/chromium
    ../../programs/alacritty
    ../../programs/zsh
    ../../programs/tmux

    ../../services/syncthing
  ];

  home.packages = with pkgs; [
    firefox
    keepassxc
    libreoffice

    # Man pages
    man-pages
    man-pages-posix

    ## C/C++
    gcc
    clang-tools

    ## Nix
    nixpkgs-fmt
    nil

    ## Rust
    rustup

    ## Python
    python3

    # Debuggers & Profilers
    gdb
    lldb
    strace
    ltrace
    valgrind
    nmap # ncat
    dig

    ffmpeg
    imagemagick
  ];
}
