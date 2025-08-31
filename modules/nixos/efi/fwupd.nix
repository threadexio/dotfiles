{ config
, pkgs
, lib
, ...
}:

let
  hasFwupd = config.services.fwupd.enable;
in

{
  boot.loader.systemd-boot.extraEntries = lib.optionalAttrs hasFwupd {
    "o_fwupd.conf" = ''
      title Firmware Updater
      efi /efi/fwupd/fwupd.efi
    '';
  };

  boot.loader.systemd-boot.extraFiles = lib.optionalAttrs hasFwupd {
    "efi/fwupd/fwupd.efi" = "${pkgs.fwupd-efi}/libexec/fwupd/efi/fwupdx64.efi";
  };

  environment.systemPackages = lib.optional hasFwupd pkgs.fwupd-efi;
}
