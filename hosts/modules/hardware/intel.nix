{ pkgs, ... }: {
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [ intel-media-driver ];
  };
}
