{ self, pkgs, ... }: {
  imports = [ ./module.nix ];

  custom.programs.librewolf = {
    enable = true;

    overrides =
      # You can use `dump-prefs.sh` to convert the prefs.js of an already configured profile
      # to the JSON file required for this.
      (builtins.fromJSON (builtins.readFile ./prefs.json))
      // {
        "browser.sessionstore.resume_from_crash" = true;
        "identity.fxaccounts.enabled" = false;
        "privacy.clearOnShutdown.downloads" = false;
        "privacy.clearOnShutdown.history" = false;
      };

    themePackage = self.packages.${pkgs.system}.firefox-mod-blur.override {
      extraMods = [
        "Search Bar Mods/Search box - No search engine buttons/no_search_engines_in_url_bar.css"
        "Icon and Button Mods/Menu icon change/menu_icon_change_to_firefox.css"
        "Tabs Bar Mods/Tabs - transparent background color/transparent_tabs_bg_color.css"
        "Icon and Button Mods/Icons in main menu/icons_in_main_menu.css"
        "Bookmarks Bar Mods/Bookmarks bar same color as toolbar/bookmarks_bar_same_color_as_toolbar.css"
        "Tabs Bar Mods/Full Width Tabs/tabs_take_full_bar_width.css"
        "Compact extensions menu/Style 1/With no settings wheel icon/cleaner_extensions_menu.css"
        "Homepage mods/Remove text from homepage shortcuts/remove_homepage_shortcut_title_text.css"
        "Min-max-close control buttons/Left side MacOS style buttons/Without animation/min-max-close_buttons.css"
      ];
    };
  };
}
