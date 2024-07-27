{
  lib,
  pkgs,
  stdenv,
  ...
}:
let
  writeScript =dest: contents:
    ''
      cat << EOF > ${dest}
      ${contents}
      EOF
      chmod -v +x ${dest}
    '';
in
stdenv.mkDerivation {
  pname = "usbguard-utils";
  version = "0.1.0";

  src = ./.;

  dontConfigure = true;

  buildInputs = with pkgs; [
    bash
    polkit
    usbguard
  ];

  buildPhase =
    lib.concatLines [
      ''
        mkdir -p $out/bin
      ''
      (writeScript "$out/bin/disable-usbguard"
        ''
          #!${pkgs.bash}/bin/bash
          pkexec ${pkgs.usbguard}/bin/usbguard set-parameter ImplicitPolicyTarget allow
        ''
      )
      (writeScript "$out/bin/enable-usbguard"
        ''
          #!${pkgs.bash}/bin/bash
          pkexec ${pkgs.usbguard}/bin/usbguard set-parameter ImplicitPolicyTarget block
        ''
      )
    ];

  doCheck = true;

  nativeCheckInputs = with pkgs; [
    shellcheck
  ];

  checkPhase = ''
    shellcheck -ax $out/bin/*
  '';

  dontInstall = true;
}
