{ stdenv
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
  getAttrOr = default: attr: set:
    if hasAttr attr set
      then set.${attr}
      else default;

  wallpaperFiles = attrNames (readDir ./src);
  baseDir = "/share/wallpapers";

  resize = args: image: res: ''
    magick ${escapeShellArg image} ${args} -resize ${res} -extent ${res} ${escapeShellArg image}.out
    mv ${escapeShellArg image}.out $out/${baseDir}/${res}/${escapeShellArg image}
  '';

  resizeFitCenterWithBackground = bg: resize "-background ${bg} -gravity center";

  wallpapers = {
    "gold-peaks.png" = resizeFitCenterWithBackground "black" "gold-peaks.png";
    "planet.jpg" = resizeFitCenterWithBackground "black" "planet.jpg";
  };
in

stdenv.mkDerivation {
  pname = "wallpapers";
  version = "0.1.0";

  src = ./src;

  nativeBuildInputs = [ imagemagick ];

  buildPhase = let
    makeResolutionSubdirs = map (res: "mkdir -p $out/${baseDir}/${res}") extraResolutions;

    exportFile = file: concatLines (map
      (getAttrOr (_: "") file wallpapers)
      extraResolutions);

    exportAll = map exportFile wallpaperFiles;
  in ''
    mkdir -p $out/${baseDir}
    cp -r ./ $out/${baseDir}/
  ''
  + (concatLines makeResolutionSubdirs)
  + (concatLines exportAll);
}
