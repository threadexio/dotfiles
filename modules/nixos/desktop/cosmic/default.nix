{ pkgs
, ...
}:

{
  imports = [
    ../common.nix
  ];

  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;

  environment.systemPackages = with pkgs; [
    work-sans
  ];
}
