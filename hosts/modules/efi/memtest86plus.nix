{ pkgs, ... }: {
  boot.loader.systemd-boot = {
    extraFiles."efi/memtest86+/memtest86+.efi" = "${pkgs.memtest86plus}/memtest.efi";

    extraEntries."p_memtest86+.conf" = ''
      title MemTest86+
      efi /efi/memtest86+/memtest86+.efi
    '';
  };

  environment.systemPackages = [ pkgs.memtest86plus ];
}
