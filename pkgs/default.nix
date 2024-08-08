{ inputs, ... }: {
  perSystem =
    { pkgs
    , inputs'
    , ...
    }: {
      packages = {
        usbguard-utils = pkgs.callPackage ./usbguard-utils { };
      };
    };
}
