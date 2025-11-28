{ config
, pkgs
, lib
, btrfsDataMount
, ...
}:

{
  sops.secrets = {
    "vaultwarden/backup_key".owner = "vaultwarden";
  };

  services.vaultwarden = {
    enable = true;

    config = {
      DOMAIN = "https://vault.31c0.org";
      SIGNUPS_ALLOWED = false;

      ROCKET_ADDRESS = "127.0.0.42";
      ROCKET_PORT = 3001;

      ROCKET_LOG = "critical";
    };

    environmentFile = pkgs.writeText "vaultwarden.env" ''
      ADMIN_TOKEN=$argon2id$v=19$m=65540,t=3,p=4$WWNFb25VejlvM3FlWTlqTGxHQ1B6WnNhbW42cGRsTGwxRkNTSEdNZW1Lbz0$K4W771ZdEJQKyynCov+KVlUxCZVYBuLkcqnaaz2JmbE
    '';
  };

  fileSystems."/var/lib/vaultwarden" = btrfsDataMount "@vaultwarden";

  systemd.timers.vaultwarden-backup = {
    description = "Vaultwarden Backup";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "02:00";
      Persistent = true;
    };
  };

  systemd.services.vaultwarden-backup = {
    description = "Vaultwarden Backup";
    conflicts = [ "vaultwarden.service" ];
    after = [ "vaultwarden.service" ];
    onSuccess = [ "vaultwarden.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = false;
      User = "vaultwarden";
      UMask = 0077;
      StateDirectory = "vaultwarden-backup";
      StateDirectoryMode = "0700";
      WorkingDirectory = "/var/lib/vaultwarden-backup";
      PrivateTmp = true;
    };

    environment = {
      PATH = lib.mkForce (lib.makeBinPath (with pkgs; [
        coreutils
        gnutar
        xz
        age
        rclone
      ]));

      RCLONE_CONFIG = "/var/lib/vaultwarden-backup/rclone.conf";
    };

    script = ''
      tar -cJp --exclude icon_cache -C /var/lib/vaultwarden . \
      | age -e -i ${config.sops.secrets."vaultwarden/backup_key".path} > /tmp/backup
      rclone moveto /tmp/backup "drive:/vaultwarden/$(date +%F).tar.xz.age"
    '';
  };

  systemd.tmpfiles.settings.vaultwarden-backup = {
    "/var/lib/vaultwarden-backup".d = {
      user = "vaultwarden";
      group = "vaultwarden";
      mode = "0700";
    };
  };
}
