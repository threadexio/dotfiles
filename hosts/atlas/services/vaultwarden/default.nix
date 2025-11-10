{ pkgs
, btrfsDataMount
, ...
}:

{
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
}
