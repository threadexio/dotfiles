{ config
, ...
}: {
  imports = [
    ./edk2-shell.nix
    ./memtest86plus.nix
  ] ++
  (if config.services.fwupd.enable then [ ./fwupd.nix ] else [ ]);

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
