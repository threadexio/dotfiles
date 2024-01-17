{ pkgs, ... }: {
  imports = [
    ./desktop.nix
  ];

  services.xserver = {
    enable = true;

    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  services.gnome.gnome-keyring.enable = true;
  services.gnome.core-shell.enable = true;

  programs.dconf.enable = true;
  programs.seahorse.enable = true;

  qt.platformTheme = "gtk";

  environment.systemPackages =
    (with pkgs; [
      gnome.adwaita-icon-theme
      gnome.gnome-tweaks
    ]);

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    liberation_ttf
  ];
}
