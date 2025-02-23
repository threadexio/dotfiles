{ pkgs, lib, ... }: with builtins; {
  programs.helix = {
    enable = true;

    ignores = filter (x: stringLength x > 0)
      (lib.splitString "\n" (readFile ./ignores));

    settings = fromTOML (readFile ./config.toml);
    languages = fromTOML (readFile ./languages.toml);
  };

  home.packages = with pkgs; [
    wl-clipboard
    xclip
  ];
}
