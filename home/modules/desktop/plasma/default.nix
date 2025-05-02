{ pkgs, ... }: {
  imports = [ ../. ];

  services.kdeconnect = {
    enable = true;
    package = pkgs.kdePackages.kdeconnect-kde;
  };

  xdg.configFile = {
    "chromium/NativeMessagingHosts/org.kde.plasma.browser_integration.json".source = "${pkgs.kdePackages.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";
  };

  home.packages = with pkgs.kdePackages; [
    konsole
    yakuake
    plasma-browser-integration
  ];
}
