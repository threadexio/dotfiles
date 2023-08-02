{ config, pkgs, ... }: {
  virtualisation.podman = {
    enable = true;

    dockerSocket.enable = true;

    enableNvidia = config.hardware ? nvidia;
  };

  environment.systemPackages = with pkgs; [ docker-compose ];

  boot.kernel.sysctl = {
    # Rootless podman
    "kernel.unprivileged_userns_clone" = 1;
  };

  # In order for rootless podman to work you must add:
  #
  # subUidRanges = [
  #   {
  #     startUid = 100000;
  #     count = 65536;
  #   }
  # ];
  #
  # subGidRanges = [
  #   {
  #     startGid = 100000;
  #     count = 65536;
  #   }
  # ];
}
