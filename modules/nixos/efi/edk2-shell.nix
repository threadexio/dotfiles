{ pkgs, ... }: {
  boot.loader.systemd-boot = {
    extraFiles."efi/edk2-shell/shell.efi" = "${pkgs.edk2-uefi-shell}/shell.efi";

    extraEntries."q_edk2-shell.conf" = ''
      title edk2-shell
      efi /efi/edk2-shell/shell.efi
    '';
  };

  environment.systemPackages = [ pkgs.edk2-uefi-shell ];
}
