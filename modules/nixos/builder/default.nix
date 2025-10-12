{ config
, ...
}:

{
  nix = {
    nrBuildUsers = 64;

    settings = {
      min-free = 10 * 1024 * 1024;
      max-free = 200 * 1024 * 1024;

      max-jobs = "auto";
      cores = 0;
    };
  };

  systemd.services.nix-daemon.serviceConfig = {
    MemoryAccounting = true;
    MemoryMax = "90%";
    OOMScoreAdjust = 500;
  };

  services.nix-serve = {
    enable = true;
    secretKeyFile = config.sops.secrets."nix_cache_private_key".path;
    openFirewall = true;
  };

  sops.secrets."nix_cache_private_key" = { };
}
