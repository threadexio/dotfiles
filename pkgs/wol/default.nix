{ stdenv
, pkgs
, ...
}:
stdenv.mkDerivation {
  pname = "wol";
  version = "0.1.0";

  src = ./.;

  buildInputs = with pkgs; [ python3 ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 ./wol.py $out/bin/wol
  '';
}
