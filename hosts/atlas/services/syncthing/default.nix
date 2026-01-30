{ config
, btrfsDataMount
, ...
}:

{
  services.syncthing = {
    enable = true;

    dataDir = "/var/lib/syncthing";
    guiAddress = "0.0.0.0:8000";

    overrideDevices = false;
    overrideFolders = false;
  };

  systemd.tmpfiles.rules = [
    "d ${config.services.syncthing.dataDir} 750 ${config.services.syncthing.user} ${config.services.syncthing.group} -"
  ];

  systemd.services.syncthing = {
    requires = ["var-lib-syncthing.mount"];
    after = ["var-lib-syncthing.mount"];
  };

  networking.firewall.allowedTCPPorts = [ 8000 ];
  fileSystems.${config.services.syncthing.dataDir} = btrfsDataMount "@syncthing";
}
