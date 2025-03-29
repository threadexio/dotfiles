{ stdenv
, lib
, makeWrapper
, coreutils
, shellcheck
, ...
}:

stdenv.mkDerivation rec {
  pname = "hackvm";
  version = "0.1.0";

  src = with lib.fileset; toSource {
    root = ./.;
    fileset = unions [
      ./hackvm.sh
      ./Dockerfile
    ];
  };

  buildInputs = [
    coreutils
  ];

  nativeBuildInputs = [
    makeWrapper
    shellcheck
  ];

  dontConfigure = true;
  doCheck = true;

  buildPhase = ''
    replace() {
      sed -i "s|$1|$2|g" ./hackvm.sh
    }
  
    replace "@PACKAGE_PREFIX@" "$out"
  '';

  checkPhase = ''
    shellcheck ./hackvm.sh
  '';

  installPhase = ''
    mkdir -p $out
    install -Dm644 ./Dockerfile $out/share/hackvm/Dockerfile
    install -Dm755 ./hackvm.sh $out/bin/hackvm
    wrapProgram $out/bin/hackvm --prefix PATH : ${lib.makeBinPath buildInputs}
  '';

  meta = with lib; {
    description = "Containers providing a standard environment for doing CTFs";
    mainProgram = "hackvm";
    platforms = platforms.all;
  };
}
