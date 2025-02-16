{ inputs, pkgs, ... }: {
  programs.helix = {
    enable = true;
    package = inputs.helix-rich-presence.packages.${pkgs.system}.default;

    # https://github.com/helix-editor/helix/wiki/Troubleshooting#on-linux
    extraPackages = with pkgs; [
      wl-clipboard
      xclip
    ];

    settings = builtins.fromTOML (builtins.readFile ./config.toml);
    languages = builtins.fromTOML (builtins.readFile ./languages.toml);
  };
}
