{ self
, inputs
, ...
}:

let
  mkPackages =
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
      btrfs-utils = x ./btrfs-utils;
    };
in

{
  _module.args = {
    overlays = [
      inputs.fabric-servers.overlays.default
      self.overlays.packages
      (final: _: {
        rich-presence-wrapper = inputs.rich-presence-wrapper.packages.${final.system}.default.override {
          programs = [
            "helix"
            "zed"
          ];
        };

        helix = final.rich-presence-wrapper;
        zed-editor = final.rich-presence-wrapper;
      })
    ];

    specialArgs = { inherit self inputs; };
  };

  flake.overlays = {
    packages = (final: _: mkPackages final);
  };

  perSystem =
    { pkgs, ... }:
    {
      packages = mkPackages pkgs;
    };
}
