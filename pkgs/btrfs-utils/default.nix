{ stdenvNoCC
, makeWrapper
, lib
, btrfs-progs
, ...
}:

with lib;

stdenvNoCC.mkDerivation {
  pname = "btrfs-utils";
  version = "0.0.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    install -Dm755 ./btrfs-snapshot.sh $out/bin/btrfs-snapshot
    wrapProgram $out/bin/btrfs-snapshot \
      --prefix PATH : ${makeBinPath [btrfs-progs]}

    runHook postInstall
  '';
}
