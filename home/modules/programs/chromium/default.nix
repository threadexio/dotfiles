{ config, pkgs, ... }: {
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;

    commandLineArgs = [
      "--enable-logging=stderr"
      "--remove-referrers"
      "--disable-top-sites"
      "--no-default-browser-check"
      "--enable-features=VaapiVideoDecodeLinuxGL"
      "--disk-cache-dir=${config.xdg.cacheHome}/chromium-cache"
      "--js-flags=--jitless"
    ];

    dictionaries = with pkgs.hunspellDictsChromium; [
      en_US
    ];

    extensions = [
      rec {
        id = "ocaahdebbfolfmndjeplogmgcagdmblk";
        version = "1.5.4.3";
        crxPath = pkgs.fetchurl {
          url = "https://github.com/NeverDecaf/chromium-web-store/releases/download/v${version}/Chromium.Web.Store.crx";
          hash = "sha256-5ZO/IG1Ap7lH2HqEwgjzln4Oi5oqxNJ4wHyxoh+ZZTI=";
        };
      }
    ];
  };
}
