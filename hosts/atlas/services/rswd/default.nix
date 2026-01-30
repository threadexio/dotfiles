{ inputs
, config
, btrfsDataMount
, ...
}:

{
  imports = [
    inputs.rswd.nixosModules.default
  ];

  sops.secrets."rswd/keyring" = {
    owner = config.systemd.services."rswd".serviceConfig.User;
  };

  services.rswd = {
    enable = true;

    settings = {
      imports = [
        "${config.sops.secrets."rswd/keyring".path}"
      ];

      http = {
        enable = true;
        bind = "tcp://0.0.0.0:8001";
      };

      shell = {
        enable = true;
        bind = "unix:///run/rswd/shell.sock";
      };

      listener = {
        bind = "tcp://0.0.0.0:50001";
        ping_interval = 5;
        update_interval = 10;
      };

      storage.autosave = {
        enable = true;
        path = "/var/lib/rswd/state.json";
        interval = 600;
      };
    };
  };

  systemd.services.rswd = {
    requires = ["var-lib-rswd.mount"];
    after = ["var-lib-rswd.mount"];

    serviceConfig = {
      RuntimeDirectory = "rswd";
      RuntimeDirectoryMode = "0700";
    };
  };

  networking.firewall.allowedTCPPorts = [ 8001 50001 50002 ];
  fileSystems."/var/lib/rswd" = btrfsDataMount "@rswd";
}
