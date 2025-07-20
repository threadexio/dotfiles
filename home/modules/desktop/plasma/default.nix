{
  pkgs,
  lib,
  ...
}:

{
  imports = [ ../. ];

  services.kdeconnect = {
    enable = true;
    package = pkgs.kdePackages.kdeconnect-kde;
  };

  xdg.configFile = {
    "chromium/NativeMessagingHosts/org.kde.plasma.browser_integration.json".source =
      "${pkgs.kdePackages.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";
  };

  xdg.dataFile = lib.mapAttrs' (
    color-scheme: type:
    lib.nameValuePair "color-schemes/${color-scheme}" {
      enable = true;
      source = ./color-schemes/${color-scheme};
    }
  ) (builtins.readDir ./color-schemes);

  home.packages = with pkgs; [
    kdePackages.konsole
    kdePackages.yakuake
    kdePackages.plasma-browser-integration

    work-sans
  ];
}
