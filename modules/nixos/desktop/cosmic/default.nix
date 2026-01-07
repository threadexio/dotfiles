{ pkgs
, ...
}:

{
  imports = [ ../common.nix ];
  
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;
  services.desktopManager.cosmic.xwayland.enable = true;
}
