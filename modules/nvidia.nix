{ lib, ... }: {
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = false;

      prime = {
        offload.enable = lib.mkForce false;
      };
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  environment.sessionVariables = {
    "LIBVA_DRIVER_NAME" = "nvidia";
    "GBM_BACKEND" = "nvidia-drm";
    "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
  };
}
