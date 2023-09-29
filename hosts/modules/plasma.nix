{ pkgs, ... }: {
  sound.enable = true;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;

    pulse.enable = true;
    jack.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };

  xdg.portal.enable = true;

  services.xserver = {
    enable = true;

    layout = "us";
    xkbVariant = "";

    desktopManager.plasma5.enable = true;
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };

      defaultSession = "plasmawayland";
    };
  };

  # Apparently KDE does not start the polkit authentication agent.
  systemd = {
    user = {
      services = {
        polkit-kde-authentication-agent-1 = {
          description = "polkit-kde-authentication-agent-1";
          wantedBy = [ "graphical-session.target" ];
          wants = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };
      };
    };
  };

  programs.kdeconnect.enable = true;

  qt.platformTheme = "kde";

  fonts.packages = [ pkgs.noto-fonts-emoji ];
}
