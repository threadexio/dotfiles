{ stdenvNoCC
, makeWrapper
, lib
, btrfs-progs
, gawk
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
      --prefix PATH : ${makeBinPath [gawk btrfs-progs]}

    runHook postInstall
  '';
}
