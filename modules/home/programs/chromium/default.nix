{ config, pkgs, ... }: {
  programs.chromium = {
    enable = true;
    package = pkgs.chromium;

    commandLineArgs = [
      "--enable-logging=stderr"
      "--remove-referrers"
      "--disable-top-sites"
      "--no-default-browser-check"
      "--enable-features=VaapiVideoDecodeLinuxGL"
      "--disk-cache-dir=${config.xdg.cacheHome}/chromium-cache"
      "--enable-features=AcceleratedVideoEncoder"
      "--ignore-gpu-blocklist"
      "--enable-zero-copy"
    ];

    dictionaries = with pkgs.hunspellDictsChromium; [
      en_US
    ];

    extensions = [
      { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # uBOL
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
      { id = "lkbajdkdffdimiecmlkmoiepfccjnmkp"; } # Sponsorblock
      { id = "hfbciigaadkcpkohaclgobbldpfjjhen"; } # Violentmonkey
    ];
  };
}
