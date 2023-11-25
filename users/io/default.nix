{ pkgs, ... }: {
  imports = [
    ../modules/zsh
  ];

  home = {
    username = "io";
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

    ## Nix
    nixpkgs-fmt

    ## Python
    python3

    ## Tools
    nmap # ncat
    dig
    ffmpeg
    imagemagick
  ];
}
