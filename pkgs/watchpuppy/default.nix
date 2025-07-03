{ stdenv
, python3
, ...
}:
stdenv.mkDerivation rec {
  pname = "watchpuppy";
  version = "0.1.0";

  src = ./.;

  buildInputs = [ python3 ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 watchpuppy $out/bin/watchpuppy
    runHook postInstall
  '';
}
