{ ... }: {
  imports = [
    ./fwupd.nix
    ./edk2-shell.nix
    ./memtest86plus.nix
  ];

  boot = {
    loader = {
      timeout = 3;

      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        editor = false;
      };
    };
  };
}
