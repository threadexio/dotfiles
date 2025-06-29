{ config, pkgs, ... }:
let
  hashedPassword = "$2b$05$5tpaRElUawEPUuIiWmZDtOpf6l0HmZNHoJsgRBQuGW2T4Wxu.nUE6";
in
{
  users.mutableUsers = false;
  users.users.kat = {
    description = "kat";
    isNormalUser = true;

    home = "/home/kat";
    createHome = true;
    homeMode = "700";

    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "podman" "wireshark" "i2c" ];

    # Rootless podman containers
    subUidRanges = [
      {
        startUid = 100000;
        count = 65536;
      }
    ];
    subGidRanges = [
      {
        startGid = 100000;
        count = 65536;
      }
    ];

    inherit hashedPassword;
  };

  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];

  systemd.tmpfiles.settings.user-private-tmp = with builtins;
    let
      isRealUser = user: user.group == "users";
      users = filter isRealUser (attrValues config.users.users);

      final = map
        (user: {
          name = "/tmp/${user.name}";
          value = {
            d = {
              user = user.name;
              group = user.group;
              mode = "0700";
            };
          };
        })
        users;
    in
    listToAttrs final;
}
