{
  # Generate a NixOS module that configures booting from a USB device.
  #
  # Parameters:
  # - `luksDevice`: Name of the LUKS device as shown in `/dev/mapper`.
  # - `keyPath`: Path to the keyfile inside the USB device. (/ is the USB root)
  # - `usbDevicePath`: Path to the USB device. This is given as an argument to
  #                    `mount` so it can by anything. Usually, it should be a
  #                    path in `/dev/disk`.
  # - `waitForDevice`: How many seconds to wait for the USB device to
  #                    be detected by the kernel. Defaults to 5 seconds.
  #                    (Optional)
  # - `allowPassword`: Allow unlocking with a password if the USB device cannot
  #                    be found. (Optional)
  unlockLuksWithUsbKey =
    { luksDevice
    , keyPath
    , usbDevice
    , waitForDevice ? 5
    , allowPassword ? true
    }:
    (
      let
        usbMountPath = "/key/${luksDevice}";
        usbFsType = "vfat";
      in
      { lib, ... }:
      {
        boot.initrd.kernelModules = [ "uas" "usbcore" "usb_storage" "vfat" "nls_cp437" "nls_iso8859_1" ];

        boot.initrd.postDeviceCommands = lib.mkBefore ''
          mkdir -m 0755 -p '${usbMountPath}'
          sleep '${builtins.toString waitForDevice}s'
          mount -n -t '${usbFsType}' -o ro '${usbDevice}' '${usbMountPath}'
        '';

        boot.initrd.postMountCommands = lib.mkBefore ''
          umount -t '${usbFsType}' '${usbMountPath}' || true
        '';

        boot.initrd.luks.devices."${luksDevice}" = {
          keyFile = "${usbMountPath}/${keyPath}";
          fallbackToPassword = allowPassword;
          preLVM = false;
        };
      }
    );
}
