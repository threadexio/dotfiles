{ config, ... }: {
  imports = [
    ./fonts.nix
    ./sound.nix
  ];

  xdg.portal.enable = true;

  hardware.i2c.enable = true;
  boot.extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
  boot.kernelModules = [ "i2c-dev" "ddcci_backlight" ];
  services.udev.extraRules = ''
    KERNEL="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';
}
