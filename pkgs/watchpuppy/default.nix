{ stdenv
, lib
, makeWrapper
, procps
, ...
}:
stdenv.mkDerivation rec {
  pname = "watchpuppy";
  version = "0.1.0";

  src = ./.;

  buildInputs = [ procps ];
  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 watchpuppy.sh $out/bin/watchpuppy
    wrapProgram $out/bin/watchpuppy --prefix PATH : ${lib.makeBinPath buildInputs}
  '';
}
