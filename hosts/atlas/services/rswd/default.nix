{ inputs
, btrfsDataMount
, ...
}:

{
  imports = [
    inputs.rswd.nixosModules.default
  ];

  services.rswd = {
    enable = true;

    settings = {
      http.bind = "0.0.0.0:8001";
      shell.bind = "0.0.0.0:50002";

      listener = {
        bind = "0.0.0.0:50001";
        ping_interval = 5;
        update_interval = 10;
      };

      storage = {
        path = "/var/lib/rswd/state.json";
        autosave = true;
        interval = 600;
      };

      keyring.path = "/var/lib/rswd/keyring";
    };
  };

  fileSystems."/var/lib/rswd" = btrfsDataMount "@rswd";
}
