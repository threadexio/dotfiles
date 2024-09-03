{ ... }: {
  perSystem =
    { pkgs, ... }: {
      packages = {
        usbguard-utils = pkgs.callPackage ./usbguard-utils { };
        firefox-mod-blur = pkgs.callPackage ./firefox-mod-blur { };
        firefox-gnome-theme = pkgs.callPackage ./firefox-gnome-theme { };
      };
    };
}
