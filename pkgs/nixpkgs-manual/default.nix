{ nixpkgs-manual
, xdg-utils
, makeWrapper
, ...
}:

nixpkgs-manual.overrideAttrs (old: {
  buildInputs = (old.buildInputs or [ ]) ++ [ xdg-utils ];

  nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ makeWrapper ];

  postInstall = (old.postInstall or "") + ''
    mkdir -p $out/bin
    makeWrapper "${xdg-utils}/bin/xdg-open" "$out/bin/nixpkgs-help" \
      --add-flags "$out/share/doc/nixpkgs/index.html"

    mkdir -p $out/share/applications
    cat << EOF > "$out/share/applications/Nixpkgs Manual.desktop"
    [Desktop Entry]
    Categories=System
    Comment=View Nixpkgs documentation in a web browser
    Exec=nixpkgs-help
    Icon=nix-snowflake
    Name=Nixpkgs Manual
    Type=Application
    EOF
  '';
})
