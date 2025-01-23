{ stdenv
, pkgs
, ...
}:
stdenv.mkDerivation {
  pname = "watchpuppy";
  version = "0.1.0";

  src = ./.;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 watchpuppy.sh $out/bin/watchpuppy
  '';
}
