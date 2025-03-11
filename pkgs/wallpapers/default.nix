{ stdenv
, symlinkJoin
, lib
, imagemagick
, extraResolutions ? [
    "1920x1080"
    "2560x1440"
    "3840x2160"
  ]
, ...
}:

with builtins;
with lib;
let
  src = ./src;
  baseDir = "/share/wallpapers";

  getAttrOr = default: attr: set:
    if hasAttr attr set then set.${attr} else default;

  wallpaperSourceFiles = attrNames (readDir src);

  resize = args: image: res: ''
    magick ${escapeShellArg image} ${args} -resize ${res} -extent ${res} ${escapeShellArg image}.out
    mv ${escapeShellArg image}.out $out/${baseDir}/${res}/${escapeShellArg image}
  '';

  resizeFitCenterWithBackground = bg: resize "-background ${bg} -gravity center";

  exportableWallpapers = {
    "gold-peaks.png" = resizeFitCenterWithBackground "black" "gold-peaks.png";
    "planet.jpg" = resizeFitCenterWithBackground "black" "planet.jpg";
  };

  commonArgs = {
    version = "0.1.0";
    inherit src;
  };

  rootWallpaperDrv = stdenv.mkDerivation (commonArgs // {
    pname = "wallpapers-root";

    installPhase = ''
      mkdir -p $out/${baseDir}/original
      cp -a ./. $out/${baseDir}/original
    '';
  });

  makeWallpaperDrv = res: stdenv.mkDerivation (commonArgs // {
    pname = "wallpapers-${res}";

    nativeBuildInputs = [ imagemagick ];

    buildPhase =
      let
        dir = "${baseDir}/${res}";

        exportWallpaper = file: (getAttrOr (_: "") file exportableWallpapers) res;
        exportWallpapers = map exportWallpaper wallpaperSourceFiles;
      in
      ''
        mkdir -p $out/${dir}
      '' + (concatLines exportWallpapers);
  });
in

symlinkJoin {
  name = "wallpapers";

  paths = [ rootWallpaperDrv ]
    ++ (map makeWallpaperDrv extraResolutions);
}
