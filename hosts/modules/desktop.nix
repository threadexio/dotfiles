{ pkgs, ... }: {
  sound.enable = true;
  security.rtkit.enable = true;

  xdg.portal.enable = true;

  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;

    pulse.enable = true;
    jack.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };

  fonts.packages = [ pkgs.noto-fonts-emoji ];
}
