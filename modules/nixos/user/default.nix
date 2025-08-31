{ config
, pkgs
, lib
, ...
}:

{
  imports = [
    ./private-tmp.nix
    ./podman.nix
  ];

  users.mutableUsers = false;
  users.users.kat = {
    description = "kat";
    isNormalUser = true;

    home = "/home/kat";
    createHome = true;
    homeMode = "700";

    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
    ]
    ++ (lib.optional config.networking.networkmanager.enable "networkmanager")
    ++ (lib.optional config.virtualisation.libvirtd.enable "libvirtd")
    ++ (lib.optional config.programs.wireshark.enable "wireshark")
    ++ (lib.optional config.hardware.i2c.enable "i2c");

    hashedPassword = "$2b$05$5tpaRElUawEPUuIiWmZDtOpf6l0HmZNHoJsgRBQuGW2T4Wxu.nUE6";
  };

  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];
}
