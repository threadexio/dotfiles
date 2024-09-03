{ pkgs
, stdenv
, ...}:
# This theme needs specific options set in the browser via `about:config`. This package
# cannot apply them automatically. Please see:
# <https://github.com/rafaelmardojai/firefox-gnome-theme?tab=readme-ov-file#required-firefox-preferences>
# for the properties that need to be changed.
stdenv.mkDerivation {
  pname = "firefox-gnome-theme";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "firefox-gnome-theme";
    rev = "fb5b578a4f49ae8705e5fea0419242ed1b8dba70";
    name = "theme";
    sha256 = "sha256-MOE9NeU2i6Ws1GhGmppMnjOHkNLl2MQMJmGhaMzdoJM=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/chrome

    cp -vr ./theme $out/chrome
    install -v -m644 -t $out/chrome \
      userChrome.css userContent.css icon.svg
  '';
}
