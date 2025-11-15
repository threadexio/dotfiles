{ python3Packages
, lib
, ...
}:

with python3Packages;

buildPythonPackage {
  pname = "cloudflare-dns";
  version = "0.1.0";

  src = with lib.fileset; toSource {
    root = ./.;
    fileset = unions [
      ./main.py
    ];
  };

  format = "other";
  propagatedBuildInputs = [ cloudflare ];

  installPhase = ''
    mkdir -p $out
    install -Dm755 ./main.py $out/bin/cloudflare-dns
  '';

  meta = {
    mainProgram = "cloudflare-dns";
  };
}
