{ config
, pkgs
, lib
, ...
}: {
  boot = {
    loader = {
      timeout = 3;

      efi = {
        efiSysMountPoint = "/boot";
        canTouchEfiVariables = true;
      };

      systemd-boot = {
        enable = true;
        editor = false;

        extraFiles =
          {
            "efi/memtest86+/memtest86+.efi" = "${pkgs.memtest86plus}/memtest.efi";
            "efi/edk2-shell/shell.efi" = "${pkgs.edk2-uefi-shell}/shell.efi";
          }
          // (
            if config.services.fwupd.enable
            then {
              "efi/fwupd/fwupd.efi" = "${pkgs.fwupd-efi}/libexec/fwupd/efi/fwupdx64.efi";
            }
            else { }
          );

        extraEntries =
          {
            "edk2-shell.conf" = ''
              title edk2-shell
              efi /efi/edk2-shell/shell.efi
            '';
            "memtest86+.conf" = ''
              title MemTest86+
              efi /efi/memtest86+/memtest86+.efi
            '';
          }
          // (
            if config.services.fwupd.enable
            then {
              "fwupd.conf" = ''
                title Firmware Updater
                efi /efi/fwupd/fwupd.efi
              '';
            }
            else { }
          );
      };
    };
  };

  environment.systemPackages = with pkgs; [ memtest86plus edk2-uefi-shell ];
}
