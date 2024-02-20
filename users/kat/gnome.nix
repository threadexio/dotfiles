{ config, lib, pkgs, ... }:
let
  wallpaperPath = ./wallpaper.webp;
in
{
  dconf.enable = true;
  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/calculator" = {
      accuracy = 9;
      button-mode = "programming";
    };
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";

      picture-options = "zoom";
      picture-uri = "file://" + wallpaperPath;
      picture-uri-dark = "file://" + wallpaperPath;
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-animations = true;
      show-battery-percentage = false;

      font-antialiasing = "grayscale";
      font-hinting = "slight";
      font-name = "Noto Sans 11";
      document-font-name = "Noto Sans 11";
      monospace-font-name = "Noto Sans Mono 10";

      gtk-enable-primary-paste = false;
      gtk-theme = config.gtk.theme.name;
      icon-theme = config.gtk.iconTheme.name;
      cursor-theme = config.gtk.cursorTheme.name;
    };
    "org/gnome/desktop/input-sources" = {
      show-all-sources = false;
      mru-sources = [ (mkTuple [ "xkb" "us" ]) ];
      sources = [
        (mkTuple [ "xkb" "us" ])
        (mkTuple [ "xkb" "gr" ])
      ];
      xkb-options = [ "terminate:ctrl_alt_bksp" ];
    };
    "org/gnome/desktop/peripherals/keyboard" = {
      numlock-state = true;
    };
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
      natural-scroll = false;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      disable-while-typing = false;
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };
    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file://" + wallpaperPath;
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };
    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 300;
    };
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Shift><Super>c" ];
      maximize = [ "<Control><Super>Up" ];
      minimize = [ "<Control><Super>Down" ];
      move-to-monitor-down = [ "<Alt><Super>Down" ];
      move-to-monitor-left = [ "<Alt><Super>Left" ];
      move-to-monitor-right = [ "<Alt><Super>Right" ];
      move-to-monitor-up = [ "<Alt><Super>Up" ];
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      toggle-fullscreen = [ "<Super>F11" ];
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      resize-with-right-button = true;
      titlebar-font = "Noto Sans 11";
    };
    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      workspaces-only-on-primary = true;
    };
    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [ "<Control><Super>Left" ];
      toggle-tiled-right = [ "<Control><Super>Right" ];
    };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = false;
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
      screensaver = [ "<Super>l" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Shift><Super>Return";
      command = "kgx";
      name = "Terminal";
    };
    "org/gnome/shell" = {
      enabled-extensions = [
        "caffeine@patapon.info"
        "clipboard-indicator@tudmotu.com"
        "focus-changer@heartmire"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "tailscale@joaophi.github.com"
        "blur-my-shell@aunetx"
        "gsconnect@andyholmes.github.io"
      ];
      favorite-apps = [
        "org.gnome.Console.desktop"
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "codium.desktop"
        "org.gnome.TextEditor.desktop"
        "com.discordapp.Discord.desktop"
        "md.obsidian.Obsidian.desktop"
        "com.valvesoftware.Steam.desktop"
      ];
    };
    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };
    "org/gnome/shell/extensions/blue-my-shell" = {
      brightness = 0.5;
      noise-amount = 0.1;
      noise-lightness = 0.87;
      sigma = 25;
    };
    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      blur = true;
    };
    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      override-background = true;
      override-background-dynamically = true;
      static-blur = false;
      style-panel = 0;
    };
    "org/gnome/shell/extensions/caffeine" = {
      indicator-position-max = 2;
    };
    "org/gnome/shell/extensions/clipboard-indicator" = {
      toggle-menu = [ "<Super>v" ];
    };
    "org/gnome/shell/extensions/focus-changer" = {
      focus-down = [ "<Super>Down" ];
      focus-left = [ "<Super>Left" ];
      focus-right = [ "<Super>Right" ];
      focus-up = [ "<Super>Up" ];
    };
    "org/gnome/keybindings" = {
      focus-active-notification = [ ];
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      toggle-message-tray = [ ];
      toggle-quick-settings = [ ];
    };
    "org/gnome/software" = {
      download-updated = false;
      download-updates-notify = true;
      first-run = false;
    };
  };

  home.packages = with pkgs.gnomeExtensions; [
    gsconnect
    clipboard-indicator
    blur-my-shell
    caffeine
    focus-changer
    tailscale-qs
  ];
}
