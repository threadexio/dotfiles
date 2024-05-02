{ pkgs, ... }: {
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
