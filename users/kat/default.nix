{ pkgs, ... }: {
  imports = [
    ./zsh
    ./dev.nix
    ./vscodium.nix
    ./credentials
    ./syncthing.nix
  ];

  home = {
    username = "kat";
    stateVersion = "23.05";
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;

  systemd.user.startServices = "sd-switch";

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
    krita
    inkscape
    gimp
    kdenlive
    obs-studio

    pop-icon-theme
    pop-gtk-theme
  ];
}
