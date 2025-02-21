{ inputs, pkgs, ... }: {
  programs.helix = {
    enable = true;
    package = inputs.rich-presence-wrapper.packages.${pkgs.system}.default;

    settings = builtins.fromTOML (builtins.readFile ./config.toml);
    languages = builtins.fromTOML (builtins.readFile ./languages.toml);
  };

  home.packages = with pkgs; [
    wl-clipboard
    xclip
  ];
}
