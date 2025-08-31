{ ...
}:

{
  imports = [ ./fwupd.nix ];

  boot.loader = {
    timeout = 3;

    efi.canTouchEfiVariables = true;

    systemd-boot = {
      enable = true;
      editor = false;

      edk2-uefi-shell.enable = true;
      memtest86.enable = true;
    };
  };
}
