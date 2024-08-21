{ config, lib, ... }: with lib;
let
  cfg = config.custom.boot.luksUsbUnlock;
in
{
  options = {
    custom.boot.luksUsbUnlock = {
      enable = mkEnableOption "unlock LUKS volumes with a USB device on boot";

      devices = mkOption {
        default = { };
        example = {
          cryptroot = {
            keyPath = "/path/to/the/key";
            usbDevice = "by-label/MY_USB";
          };
        };
        type = types.attrsOf (types.submodule {
          options = {
            keyPath = mkOption {
              example = "/mykey.key";
              description = mdDoc ''
                Path to the key file inside the USB device's filesystem.
                `/` is relative to the device's filesystem root.
              '';
              type = types.str;
            };

            usbDevice = mkOption {
              example = "by-label/BOOTKEY";
              description = mdDoc ''
                Path to the USB device that contains the keys. (Path relative to `/dev/disk/`)
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
          };
        });
      };
    };
  };

  config = mkIf cfg.enable
    (
      let
        makeUsbDevPath = usbDevice: "/dev/disk/" + usbDevice;
        makeMountPath = usbDevice: "/key/" + (builtins.hashString "md5" usbDevice);
        usbFsType = "vfat";

        mapAttrsNameValue = f: set:
          listToAttrs (map f (attrsToList set));
      in
      {
        boot.initrd.kernelModules = [ "uas" "usbcore" "usb_storage" "vfat" "nls_cp437" "nls_iso8859_1" ];

        boot.initrd.systemd.services =
          let
            makeService = name: { keyPath, usbDevice, waitForDevice }:
              let
                usbDevPath = makeUsbDevPath usbDevice;
                usbMountPath = makeMountPath usbDevice;
              in
              {
                description = "Mount ${name} key";
                wantedBy = [ "cryptsetup.target" ];
                before = [ "systemd-cryptsetup@${name}.service" ];
                after = [ "systemd-modules-load.service" ];
                unitConfig.DefaultDependencies = "no";
                serviceConfig.Type = "oneshot";

                script = ''
                  if mountpoint -q ${escapeShellArg usbMountPath}; then
                    exit 0
                  fi

                  if [ ! -e ${escapeShellArg usbDevPath} ]; then
                    sleep ${escapeShellArg waitForDevice}s
                  fi

                  if [ -e ${escapeShellArg usbDevPath} ]; then
                    mkdir -m0500 -p ${escapeShellArg usbMountPath}
                    mount -n -t ${escapeShellArg usbFsType} -o ro ${escapeShellArg usbDevPath} ${escapeShellArg usbMountPath}
                  fi
                '';
              };
          in
          mapAttrsNameValue
            ({ name, value }: {
              name = "luksusb-${name}";
              value = makeService name value;
            })
            cfg.devices;

        boot.initrd.luks.devices = builtins.mapAttrs
          (name: { keyPath, usbDevice, ... }:
            let
              usbMountPath = makeMountPath usbDevice;
            in
            {
              keyFile = "${usbMountPath}/${keyPath}";
              keyFileTimeout = 1;
            })
          cfg.devices;
      }
    );
}
