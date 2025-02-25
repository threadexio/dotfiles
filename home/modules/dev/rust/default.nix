{ config, pkgs, ... }:

let
  cargoConfig = pkgs.writeTextFile {
    name = "cargo-config";
    text = ''
[build]
target-dir = "${config.home.homeDirectory}/build"

[target.x86_64-unknown-linux-gnu]
linker = "${pkgs.clang}/bin/clang"
rustflags = ["-C", "link-arg=--ld-path=${pkgs.mold}/bin/mold"]

[future-incompat-report]
frequency = "always"

[cargo-new]
vcs = "none"
    '';

    destination = "/config.toml";

    derivationArgs = {
      buildInputs = [
        pkgs.clang
        pkgs.mold
      ];
    };
  };
in

{
  home.sessionPath = [
    "${config.home.homeDirectory}/.cargo/bin"
  ];

  home.file.".cargo/config.toml".source = "${cargoConfig}/config.toml";

  home.packages = with pkgs; [
    rustup
    cargoConfig
  ];
}
