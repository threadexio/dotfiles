{ btrfsDataMount
, ...
}:

{
  services.vaultwarden = {
    enable = true;

    config = {
      DOMAIN = "https://q0.ddns.net/vault";
      SIGNUPS_ALLOWED = false;

      ROCKET_ADDRESS = "127.0.0.42";
      ROCKET_PORT = 3001;

      ROCKET_LOG = "critical";
    };
  };

  fileSystems."/var/lib/vaultwarden" = btrfsDataMount "@vaultwarden";
}
