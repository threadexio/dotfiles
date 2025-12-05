{ inputs
, pkgs
, ...
}:

{
  imports = [
    ../common.nix

    ./fix-126590.nix
  ];

  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
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
            ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };
      };
    };
  };

  qt.platformTheme = "kde";

  environment.systemPackages = with pkgs; [
    kdePackages.kolourpaint
    inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
  ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    oxygen
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
