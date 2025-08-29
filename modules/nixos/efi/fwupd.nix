{ pkgs, ... }: {
  boot.loader.systemd-boot = {
    extraFiles."efi/fwupd/fwupd.efi" = "${pkgs.fwupd-efi}/libexec/fwupd/efi/fwupdx64.efi";

    extraEntries."o_fwupd.conf" = ''
      title Firmware Updater
      efi /efi/fwupd/fwupd.efi
    '';
  };

  environment.systemPackages = [ pkgs.fwupd-efi ];
}
