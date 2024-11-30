{ pkgs, ... }: {
  imports = [
    ../modules/core

    ../modules/programs/zsh
    ../modules/programs/tmux

    ../modules/programs/git
    ../modules/programs/gpg
    ../modules/programs/ssh

    ../modules/plasma
    ../modules/programs/alacritty
    ../modules/programs/yakuake
    ../modules/programs/helix
    ../modules/programs/zed

    ../modules/programs/chromium
    ../modules/programs/librewolf

    ../modules/services/syncthing
  ];

  home.packages = with pkgs; [
    keepassxc
    libreoffice
    inkscape
    gimp
    mpv
    easyeffects

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
