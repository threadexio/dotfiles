{ pkgs
, stdenv
, ...
}:
stdenv.mkDerivation {
  pname = "bali-firefoxcss";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "Bali10050";
    repo = "FirefoxCSS";
    rev = "b0f21688f20c24b1937b3b398307e813bca6af38";
    sha256 = "sha256-FrFbl6w/l49mrweFontBTdJSSkvnNhrsuE/MhNfOgkM=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/chrome

    cp -vr ./chrome $out
  '';
}
