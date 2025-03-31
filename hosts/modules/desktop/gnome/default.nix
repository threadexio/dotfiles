{ pkgs, ... }: {
  imports = [
    ../common.nix
  ];

  services.xserver = {
    enable = true;

    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

  services.udev.packages = with pkgs; [ gnome-settings-daemon ];

  services.gnome.gnome-keyring.enable = true;
  services.gnome.core-shell.enable = true;

  programs.dconf.enable = true;
  programs.seahorse.enable = true;

  qt.platformTheme = "gtk";

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    gnome-tweaks
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
