pkgs:

let
  x = p: pkgs.callPackage p { };
in

{
  wol = x ./wol;
  watchpuppy = x ./watchpuppy;
  usbguard-utils = x ./usbguard-utils;
  firefox-mod-blur = x ./firefox-mod-blur;
  firefox-gnome-theme = x ./firefox-gnome-theme;
  bali-firefoxcxx = x ./bali-firefoxcss;
  virt-clone-cheap = x ./virt-clone-cheap;
  wallpapers = x ./wallpapers;
  hackvm = x ./hackvm;
}
