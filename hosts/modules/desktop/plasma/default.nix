{ pkgs, ... }: {
  imports = [
    ../common.nix
  ];

  services.xserver = {
    enable = true;

    desktopManager.plasma5.enable = true;
    displayManager.gdm.enable = true;
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
}
