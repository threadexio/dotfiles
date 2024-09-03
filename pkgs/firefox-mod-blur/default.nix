{ lib
, pkgs
, stdenv
  # Additional theme mods to install. List of paths to the CSS files relative to the repo's
  # `EXTRA MODS/` directory.
, extraMods ? [ ]
, ...
}:
stdenv.mkDerivation {
  pname = "firefox-mod-blur";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "datguypiko";
    repo = "Firefox-Mod-Blur";
    rev = "651c33cdaef9a48ad272205f6db7fcf686856ba4";
    name = "theme";
    sha256 = "sha256-R/S2toAatIMoyebmvdSn2BsrvgHaCgP1um5yG31QQmM=";
  };

  installPhase =
    let
      copyToChrome = [ "userChrome.css" "userContent.css" ]
        ++ (map (x: "EXTRA MODS/${x}") extraMods);

      copyToChromePaths = map (x: "./${x}") copyToChrome;
    in
    ''
      mkdir -p $out/chrome

      cp -vr ./ASSETS $out/chrome
      install -v -m644 -t $out/chrome \
        ${lib.escapeShellArgs copyToChromePaths}
    '';
}
