{ stdenvNoCC
, makeWrapper
, coreutils
, gnugrep
, iproute2
, gawk
, systemd
, lib
, ...
}:

with lib;

stdenvNoCC.mkDerivation {
  pname = "watchpuppy-misc";
  version = "0.0.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    install -Dm755 ./check/00-users.sh $out/share/watchpuppy/check/00-users.sh
    wrapProgram $out/share/watchpuppy/check/00-users.sh \
      --prefix PATH : ${makeBinPath [coreutils]}

    install -Dm755 ./check/10-tcp.sh $out/share/watchpuppy/check/10-tcp.sh
    wrapProgram $out/share/watchpuppy/check/10-tcp.sh \
      --prefix PATH : ${makeBinPath [coreutils gnugrep iproute2 gawk]}

    install -Dm755 ./run/99-suspend.sh $out/share/watchpuppy/run/99-suspend.sh
    wrapProgram $out/share/watchpuppy/run/99-suspend.sh \
      --prefix PATH : ${makeBinPath [systemd]}
  '';
}
