{ pkgs, lib, ... }: with builtins;
let
  readTOML = path: fromTOML (readFile path);
in
{
  programs.helix = {
    enable = true;

    ignores = filter (x: stringLength x > 0)
      (lib.splitString "\n" (readFile ./ignore));

    settings = readTOML ./config.toml;
    languages = readTOML ./languages.toml;

    themes = let
      themeFiles = attrNames (readDir ./themes);

      themes = map (themeFile: {
        name = lib.removeSuffix ".toml" themeFile;
        value = readTOML ./themes/${themeFile};
      }) themeFiles;
    in
      listToAttrs themes;
  };

  home.packages = with pkgs; [
    wl-clipboard
    xclip
  ];
}
