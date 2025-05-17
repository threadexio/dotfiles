{ self
, pkgs
, lib
, ...
}:

{
  home.packages = with pkgs; [
    discord
  ];

  nixpkgs.overlays = [ self.overlays.rich-presence-wrapper ];
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "discord" ];
}
