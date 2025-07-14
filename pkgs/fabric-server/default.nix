{ stdenvNoCC
, fetchurl
, makeWrapper
, lib

, jre
, udev

, version ? "1.21.4"
, loaderVersion ? "0.16.14"
, installerVersion ? "1.0.3"
, ...
}:

with lib;

stdenvNoCC.mkDerivation {
  pname = "fabric";
  inherit version;

  src = fetchurl {
    pname = "fabric-jar";
    inherit version;

    url = "https://meta.fabricmc.net/v2/versions/loader/${version}/${loaderVersion}/${installerVersion}/server/jar";
    hash = "sha256-xQdPurp4NNQ9m77QvhWXNeeYv+Tq9zXCXIJeZZ/iqwM=";
  };

  buildInputs = [ jre udev ];
  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    
    install -Dm644 $src $out/share/fabric/fabric.jar

    makeWrapper ${getExe jre} "$out/bin/minecraft-server" \
      --append-flags "-jar $out/share/fabric/fabric.jar nogui" \
      ${optionalString stdenvNoCC.hostPlatform.isLinux "--prefix LD_LIBRARY_PATH : ${makeLibraryPath [ udev ]}"}

    runHook postInstall
  '';

  preferLocalBuild = true;
}
