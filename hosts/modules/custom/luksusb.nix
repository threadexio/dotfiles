{ config, lib, ... }: with lib; let
  cfg = config.custom.boot.luksUsbUnlock;
in
{
  options = {
    custom.boot.luksUsbUnlock = {
      enable = mkEnableOption "unlock LUKS volumes with a USB device on boot";

      usbDevice = mkOption {
        example = "/dev/disk/by-label/BOOTKEY";
        description = mdDoc ''
          Path to the USB device that contains the keys.
        '';
        type = types.str;
      };

      waitForDevice = mkOption {
        default = 5;
        example = 10;
        description = mdDoc ''
          How many seconds to wait for the USB device to be detected by the
          kernel.
        '';
        type = types.ints.unsigned;
      };

      devices = mkOption {
        default = { };
        example = {
          cryptroot.keyPath = "/path/to/the/key";
        };
        type = types.attrsOf (types.submodule (
          { name, ... }: {
            options = {
              keyPath = mkOption {
                example = "/mykey.key";
                description = mdDoc ''
                  Path to the key file inside the USB device's filesystem.
                  `/` is relative to the device's filesystem root.
                '';
                type = types.str;
              };

              allowPassword = mkOption {
                default = true;
                example = false;
                description = mdDoc ''
                  Whether to allow using a passphrase to unlock the volume if
                  the device or the key could not be accessed.
                '';
                type = types.bool;
              };
            };
          }
        ));
      };
    };
  };

  config = mkIf cfg.enable (
    let
      usbMountPath = "/key/" + (builtins.hashString "md5" cfg.usbDevice);
      usbFsType = "vfat";
    in
    {
      boot.initrd.kernelModules = [ "uas" "usbcore" "usb_storage" "vfat" "nls_cp437" "nls_iso8859_1" ];

      boot.initrd.postDeviceCommands = mkBefore ''
        mkdir -m 0755 -p '${usbMountPath}'
        sleep '${builtins.toString cfg.waitForDevice}s'
        mount -n -t '${usbFsType}' -o ro '${cfg.usbDevice}' '${usbMountPath}'
      '';

      boot.initrd.postMountCommands = mkBefore ''
        umount '${usbMountPath}'
        eject '${cfg.usbDevice}'
      '';

      boot.initrd.luks.devices = builtins.mapAttrs
        (_: { keyPath, allowPassword }: {
          keyFile = "${usbMountPath}/${keyPath}";
          fallbackToPassword = allowPassword;
        })
        cfg.devices;
    }
  );
}
