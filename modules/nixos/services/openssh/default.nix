{ config
, ...
}:

{
  sops.secrets = {
    "ssh/host_ed25519_key" = { };
    "ssh/host_rsa_key" = { };
  };

  services.openssh = {
    enable = true;

    settings = {
      UseDns = false;
      PermitRootLogin = "prohibit-password";
    };

    hostKeys = [
      {
        type = "ed25519";
        inherit (config.sops.secrets."ssh/host_ed25519_key") path;
      }
      {
        type = "rsa";
        inherit (config.sops.secrets."ssh/host_rsa_key") path;
      }
    ];
  };
}
