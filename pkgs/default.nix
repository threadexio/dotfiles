{ ...
}:

{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        bali-firefoxcxx = pkgs.callPackage ./bali-firefoxcss { };
        btrfs-utils = pkgs.callPackage ./btrfs-utils { };
        cloudflare-dns = pkgs.callPackage ./cloudflare-dns { };
        firefox-gnome-theme = pkgs.callPackage ./firefox-gnome-theme { };
        firefox-mod-blur = pkgs.callPackage ./firefox-mod-blur { };
        hackvm = pkgs.callPackage ./hackvm { };
        nixpkgs-manual = pkgs.callPackage ./nixpkgs-manual { };
        usbguard-utils = pkgs.callPackage ./usbguard-utils { };
        virt-clone-cheap = pkgs.callPackage ./virt-clone-cheap { };
        wallpapers = pkgs.callPackage ./wallpapers { };
        wol = pkgs.callPackage ./wol { };
      };
    };

  flake.overlays = {
    packages = final: prev: {
      bali-firefoxcxx = final.callPackage ./bali-firefoxcss { };
      btrfs-utils = final.callPackage ./btrfs-utils { };
      cloudflare-dns = final.callPackage ./cloudflare-dns { };
      firefox-gnome-theme = final.callPackage ./firefox-gnome-theme { };
      firefox-mod-blur = final.callPackage ./firefox-mod-blur { };
      hackvm = final.callPackage ./hackvm { };
      usbguard-utils = final.callPackage ./usbguard-utils { };
      virt-clone-cheap = final.callPackage ./virt-clone-cheap { };
      wallpapers = final.callPackage ./wallpapers { };
      wol = final.callPackage ./wol { };
    };

    nixpkgs-manual = final: prev: {
      nixpkgs-manual = final.callPackage ./nixpkgs-manual { inherit (prev) nixpkgs-manual; };
    };
  };
}
