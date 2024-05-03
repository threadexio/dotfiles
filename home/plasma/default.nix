{ pkgs, ... }: {
  services.kdeconnect.enable = true;

  xdg.configFile = {
    "chromium/NativeMessagingHosts/org.kde.plasma.browser_integration.json".source = "${pkgs.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";
  };

  home.packages = with pkgs; [ plasma-browser-integration ];
}
