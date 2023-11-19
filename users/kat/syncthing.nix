{ ... }: {
  services.syncthing = {
    enable = true;

    extraOptions = [
      "--no-default-folder"
      "--gui-address=127.0.0.1:8443"
    ];

    tray = {
      enable = false;
    };
  };
}
