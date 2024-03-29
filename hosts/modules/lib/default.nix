{
  # Generate a NixOS module that configures booting from a USB device.
  #
  # Parameters:
  # - `devices`: Map of LUKS device names to set `Device`.
  # - `usbDevice`: Path to the USB device. This is given as an argument to
  #                `mount` so it can by anything. Usually, it should be a
  #                path in `/dev/disk`.
  # - `waitForDevice`: How many seconds to wait for the USB device to
  #                    be detected by the kernel. Defaults to 5 seconds.
  #                    (Optional)
  #
  # Device:
  # - `keyPath`: Path to the key file inside of the USB device. (/ is device root)
  # - `allowPassword`: Allow unlocking by a password if the key cannot be found.
  #                    Defaults to `true`. (Optional)
  #
  unlockLuksWithUsbKey =
    { devices
    , usbDevice
    , waitForDevice ? 5
    }:
    (
      let
        usbMountPath = "/key/" + (builtins.hashString "md5" usbDevice);
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
          umount '${usbMountPath}'
          eject '${usbDevice}'
        '';

        boot.initrd.luks.devices =
          let
            f =
              { keyPath
              , allowPassword ? true
              }: {
                keyFile = "${usbMountPath}/${keyPath}";
                fallbackToPassword = allowPassword;
                preLVM = false;
              };
          in
          builtins.mapAttrs (luksname: f) devices;
      }
    );

  # Mount a `tmpfs` filesystem.
  #
  # Parameters:
  # - `path`: Mount point.
  # - `size`: Capacity of the filesystem.
  # - `owner`: User who will own the mount. (Optional)
  # - `group`: Group who will own the mount. (Optional)
  # - `mode`: Permissions of the mount. Defaults to 0700.
  # - `extraOptions`: Additional options that should be passed to `mount`.
  #                   See: `man 5 tmpfs`. (Optional)
  mountTmpfs = { path, size, owner ? null, group ? null, mode ? "0700", extraOptions ? [ ] }:
    { config, ... }: {
      fileSystems."${path}" = {
        fsType = "tmpfs";
        options = [ "size=${size}" "mode=${mode}" "huge=always" ]

          ++ (if !(builtins.isNull owner) then [ "uid=${owner}" ] else [ ])
          ++ (if !(builtins.isNull group) then [ "gid=${group}" ] else [ ])
          ++ extraOptions

        ;
      };
    };
}
