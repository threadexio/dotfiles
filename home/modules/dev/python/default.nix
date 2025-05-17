{ pkgs, ... }:

let
  python3 = pkgs.python3.withPackages (p: with p; [
    python-lsp-server
    virtualenv

    pwntools
  ]);
in

{
  home.packages = [ python3 ];
}
