{ stdenvNoCC
, lib

, makeWrapper
, shellcheck
, netcat
, ...
}:

stdenvNoCC.mkDerivation {
  name = "minecraft-server-wait-up";

  src = ./.;

  nativeBuildInputs = [
    makeWrapper
    shellcheck
  ];

  buildInputs = [ netcat ];

  doCheck = true;
  checkPhase = ''
    shellcheck ./wait-up.sh;
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    install -m755 ./wait-up.sh $out/bin/wait-up
    wrapProgram $out/bin/wait-up \
      --prefix PATH : "${lib.makeBinPath [ netcat ]}"
  '';

  meta.mainProgram = "wait-up";
}
