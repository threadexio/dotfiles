{ btrfsDataMount
, ...
}:

{
  containers.vsftpd = {
    privateUsers = "no";
    privateNetwork = false;
    ephemeral = true;
    autoStart = true;

    bindMounts."/data" = {
      hostPath = "/var/lib/vsftpd";
      isReadOnly = false;
    };

    forwardPorts = [
      {
        containerPort = 21;
        hostPort = 21;
        protocol = "tcp";
      }
    ];

    config =
      let
        users = [
          { user = "user"; hashedPassword = "$y$j9T$UE.NzNckqmwmEKwZfCeX60$D7a/w29Pgyil1wJycvVn5FfulVgvFN9idYW0oXmk/2B"; }
          { user = "printer"; hashedPassword = "$y$j9T$HfxxnKfjNQ7.xtDojuLuI0$qOBCBm0Fw6dMlAOlAs5Vv/EkOv67FI8Cp9X12d0NCY9"; }
        ];
      in
      { pkgs, lib, ... }: {
        services.vsftpd = {
          enable = true;

          writeEnable = true;
          allowWriteableChroot = true;

          localUsers = true;
          anonymousUser = false;
          chrootlocalUser = true;

          userlistEnable = true;
          userlistDeny = false;
          userlistFile = pkgs.writeText "vsftpd-userlist"
            (lib.concatLines (map (x: x.user) users));

          extraConfig = ''
            local_umask=0027
          '';
        };

        systemd.tmpfiles.rules = [
          "d  /data 770 vsftpd vsftpd -"
        ];

        users.users = lib.listToAttrs (map
          ({ user, hashedPassword }:
            lib.nameValuePair user {
              inherit hashedPassword;

              group = "vsftpd";
              isNormalUser = true;

              createHome = false;
              home = "/data";
            }
          )
          users);

        system.stateVersion = "25.05";
      };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/vsftpd 770 root root -"
  ];

  fileSystems."/var/lib/vsftpd" = btrfsDataMount "@vsftpd";
}
