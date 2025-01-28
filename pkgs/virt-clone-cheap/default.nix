{ stdenv
, lib
, makeWrapper
, virt-manager
, ...
}:

stdenv.mkDerivation rec {
  pname = "virt-clone-cheap";
  version = "0.1.0";

  src = ./.;

  buildInputs = [ virt-manager ];
  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 ./virt-clone-cheap.sh $out/bin/virt-clone-cheap
    wrapProgram $out/bin/virt-clone-cheap --prefix PATH : ${lib.makeBinPath buildInputs}
  '';
}
