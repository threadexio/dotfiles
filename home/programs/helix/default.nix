{ pkgs, ... }: {
  programs.helix = {
    enable = true;

    # https://github.com/helix-editor/helix/wiki/Troubleshooting#on-linux
    extraPackages = with pkgs; [
      wl-clipboard
      xclip
    ];

    settings = builtins.fromTOML (builtins.readFile ./config.toml);
  };
}
