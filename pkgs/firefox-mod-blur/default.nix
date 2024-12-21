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
    rev = "02f4de894d94a79505b5b10a42c9af06aa7e4819";
    name = "theme";
    sha256 = "sha256-Pc2BQuHYDtKexQKwT2wpphRAFuW29grZoCuqzG/xYLM=";
  };

  dontConfigure = true;
  dontBuild = true;

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
