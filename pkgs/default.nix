{ ... }: {
  perSystem =
    { pkgs, ... }: {
      packages = {
        wol = pkgs.callPackage ./wol { };
        watchpuppy = pkgs.callPackage ./watchpuppy { };
        usbguard-utils = pkgs.callPackage ./usbguard-utils { };
        firefox-mod-blur = pkgs.callPackage ./firefox-mod-blur { };
        firefox-gnome-theme = pkgs.callPackage ./firefox-gnome-theme { };
        bali-firefoxcxx = pkgs.callPackage ./bali-firefoxcss { };
        virt-clone-cheap = pkgs.callPackage ./virt-clone-cheap { };
      };
    };
}
