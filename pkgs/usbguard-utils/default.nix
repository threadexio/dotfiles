{ lib
, pkgs
, stdenv
, ...
}:
stdenv.mkDerivation {
  pname = "usbguard-utils";
  version = "0.1.0";

  src = ./.;

  buildInputs = with pkgs; [
    bash
    polkit
    usbguard
  ];

  nativeCheckInputs = with pkgs; [
    shellcheck
  ];

  dontConfigure = true;
  doCheck = true;
  dontBuild = true;

  checkPhase = ''
    shellcheck -ax usbguard-utils.sh
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 ./usbguard-utils.sh $out/bin/usbguard-utils

    ln -rsf $out/bin/usbguard-utils $out/bin/enable-usbguard
    ln -rsf $out/bin/usbguard-utils $out/bin/disable-usbguard
  '';

}
