{ pkgs
, lib
, ...
}:
{
  imports = [ ../. ];

  programs.gnome-shell.enable = true;
  programs.gnome-shell.extensions = with pkgs.gnomeExtensions; [
    { package = appindicator; }
    { package = clipboard-indicator; }
    { package = focus-changer; }
    { package = gsconnect; }
    { package = caffeine; }
  ];

  dconf.enable = true;
  dconf.settings =
    let
      wallpaperPath = "${pkgs.wallpapers}/share/wallpapers/3840x2160/planet.jpg";
    in
    {
      "org/gnome/mutter" = {
        dynamic-workspaces = false;
      };

      "org/gnome/mutter/keybindings" = {
        toggle-tiled-left = [ "<Control><Super>Left" ];
        toggle-tiled-right = [ "<Control><Super>Right" ];
      };

      "org/gnome/shell" = {
        enabled-extensions = [
          "appindicatorsupport@rgcjonas.gmail.com"
          "clipboard-indicator@tudmotu.com"
          "focus-changer@heartmire"
          "gsconnect@andyholmes.github.io"
          "caffeine@patapon.info"
          "system-monitor@gnome-shell-extensions.gcampax.github.com"
        ];
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

      "org/gnome/shell/extensions/system-monitor" = {
        show-swap = false;
      };

      "org/gnome/shell/keybindings" = {
        switch-to-application-1 = [ ];
        switch-to-application-2 = [ ];
        switch-to-application-3 = [ ];
        switch-to-application-4 = [ ];

        toggle-message-tray = [ ];
        toggle-overview = [ "<Super>w" ];
      };

      "org/gnome/Console" = {
        ignore-scrollback-limit = true;
      };

      "org/gnome/desktop/background" = {
        color-shading-type = "solid";
        picture-options = "zoom";
        picture-uri = "file://${wallpaperPath}";
        picture-uri-dark = "file://${wallpaperPath}";
        primary-color = "#000000000000";
        secondary-color = "#000000000000";
      };

      "org/gnome/desktop/input-sources" = {
        sources = map lib.hm.gvariant.mkTuple [
          [ "xkb" "us" ]
          [ "xkb" "gr" ]
        ];
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        font-antialiasing = "rgba";
        font-hinting = "slight";
        show-battery-percentage = false;
        toolback-style = "text";
      };

      "org/gnome/desktop/privacy" = {
        remember-recent-files = false;
        remove-old-temp-files = true;
        remove-old-trash-files = true;
      };

      "org/gnome/desktop/screensaver" = {
        picture-options = "zoom";
        picture-uri = "file://${wallpaperPath}";
        primary-color = "#000000000000";
        secondary-color = "#000000000000";
      };

      "org/gnome/desktop/search-providers" = {
        disabled = [
          "org.gnome.Nautilus.desktop"
          "org.gnome.Calendar.desktop"
          "org.gnome.seahorse.Application.desktop"
          "org.gnome.Software.desktop"
          "org.gnome.Epiphany.desktop"
          "org.gnome.Contacts.desktop"
        ];
      };

      "org/gnome/desktop/wm/keybindings" = {
        activate-window-menu = [ ];
        close = [ "<Shift><Super>c" ];
        maximize = [ "<Super>Page_Up" ];

        move-to-monitor-down = [ "<Alt><Super>Down" ];
        move-to-monitor-left = [ "<Alt><Super>Left" ];
        move-to-monitor-right = [ "<Alt><Super>Right" ];
        move-to-monitor-up = [ "<Alt><Super>Up" ];

        move-to-workspace-1 = [ "<Shift><Super>1" ];
        move-to-workspace-2 = [ "<Shift><Super>2" ];
        move-to-workspace-3 = [ "<Shift><Super>3" ];
        move-to-workspace-4 = [ "<Shift><Super>4" ];

        move-to-workspace-last = [ ];
        move-to-workspace-next = [ ];
        move-to-workspace-down = [ ];
        move-to-workspace-left = [ ];
        move-to-workspace-right = [ ];
        move-to-workspace-up = [ ];

        switch-to-workspace-1 = [ "<Super>1" ];
        switch-to-workspace-2 = [ "<Super>2" ];
        switch-to-workspace-3 = [ "<Super>3" ];
        switch-to-workspace-4 = [ "<Super>4" ];

        switch-to-workspace-down = [ ];
        switch-to-workspace-last = [ ];
        switch-to-workspace-left = [ ];
        switch-to-workspace-right = [ ];
        switch-to-workspace-up = [ ];

        toggle-fullscreen = [ "F11" ];
        toggle-maximized = [ ];
        unmaximize = [ "<Super>Page_Down" ];
      };

      "org/gnome/desktop/wm/preferences" = {
        auto-raise = false;
        focus-mode = "mouse";
        num-workspaces = 4;
      };
    };

  gtk = {
    enable = true;

    cursorTheme = {
      package = pkgs.pop-gtk-theme;
      name = "Pop";
    };

    iconTheme = {
      package = pkgs.pop-icon-theme;
      name = "Pop";
    };

    theme = {
      package = pkgs.pop-gtk-theme;
      name = "Pop";
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  qt = {
    enable = true;
    platformTheme = {
      name = "gtk3";
    };
  };
}
