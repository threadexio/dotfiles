{ pkgs, ... }: {
  programs.helix = {
    enable = true;

    settings = builtins.fromTOML (builtins.readFile ./config.toml);
    languages = builtins.fromTOML (builtins.readFile ./languages.toml);
  };

  home.packages = with pkgs; [
    wl-clipboard
    xclip
  ];
}
