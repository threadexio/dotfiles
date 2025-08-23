{ self
, inputs
, ...
}:

{
  _module.args = {
    overlays = [
      inputs.fabric-servers.overlays.default

      inputs.rich-presence-wrapper.overlays.default
      inputs.rich-presence-wrapper.overlays.helix
      inputs.rich-presence-wrapper.overlays.zed-editor

      self.overlays.packages
      self.overlays.nixpkgs-manual
    ];

    specialArgs = { inherit self inputs; };
  };

  perSystem =
    { pkgs, ... }:
    {
      packages = {
        bali-firefoxcxx = pkgs.callPackage ./bali-firefoxcss { };
        btrfs-utils = pkgs.callPackage ./btrfs-utils { };
        firefox-gnome-theme = pkgs.callPackage ./firefox-gnome-theme { };
        firefox-mod-blur = pkgs.callPackage ./firefox-mod-blur { };
        hackvm = pkgs.callPackage ./hackvm { };
        nixpkgs-manual = pkgs.callPackage ./nixpkgs-manual { };
        usbguard-utils = pkgs.callPackage ./usbguard-utils { };
        virt-clone-cheap = pkgs.callPackage ./virt-clone-cheap { };
        wallpapers = pkgs.callPackage ./wallpapers { };
        watchpuppy = pkgs.callPackage ./watchpuppy { };
        wol = pkgs.callPackage ./wol { };
      };
    };

  flake.overlays = {
    packages = final: prev: {
      bali-firefoxcxx = final.callPackage ./bali-firefoxcss { };
      btrfs-utils = final.callPackage ./btrfs-utils { };
      firefox-gnome-theme = final.callPackage ./firefox-gnome-theme { };
      firefox-mod-blur = final.callPackage ./firefox-mod-blur { };
      hackvm = final.callPackage ./hackvm { };
      usbguard-utils = final.callPackage ./usbguard-utils { };
      virt-clone-cheap = final.callPackage ./virt-clone-cheap { };
      wallpapers = final.callPackage ./wallpapers { };
      watchpuppy = final.callPackage ./watchpuppy { };
      wol = final.callPackage ./wol { };
    };

    nixpkgs-manual = final: prev: {
      nixpkgs-manual = final.callPackage ./nixpkgs-manual { inherit (prev) nixpkgs-manual; };
    };
  };
}
