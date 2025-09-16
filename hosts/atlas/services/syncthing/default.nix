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

  fileSystems.${config.services.syncthing.dataDir} = btrfsDataMount "@syncthing";
}
