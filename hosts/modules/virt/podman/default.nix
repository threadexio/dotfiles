{ config
, pkgs
, lib
, ...
}: {
  virtualisation.podman = {
    enable = true;

    defaultNetwork.settings = {
      dns_enabled = true;
    };

    dockerSocket.enable = true; # for docker-compose
    enableNvidia = config.hardware ? nvidia;
  };

  environment.systemPackages = with pkgs; [ docker-compose ];

  boot.kernel.sysctl = lib.mkForce {
    # Rootless podman
    "kernel.unprivileged_userns_clone" = 1; # TODO: check that this doesnt overwrite the hardning options
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
