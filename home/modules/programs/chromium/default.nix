{ config, pkgs, ... }: {
  programs.chromium = {
    enable = true;
    package = pkgs.chromium.override { enableWideVine = true; };

    commandLineArgs = [
      "--enable-logging=stderr"
      "--remove-referrers"
      "--disable-top-sites"
      "--no-default-browser-check"
      "--enable-features=VaapiVideoDecodeLinuxGL"
      "--disk-cache-dir=${config.xdg.cacheHome}/chromium-cache"
      "--js-flags=--jitless"
    ];

    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # Privacy Badger
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
      { id = "kjjgifdfplpegljdfnpmbjmkngdilmkd"; } # Link Hints
    ];
  };
}
