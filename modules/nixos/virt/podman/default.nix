{ pkgs
, lib
, ...
}: {
  virtualisation.podman = {
    enable = true;

    defaultNetwork.settings = {
      dns_enabled = true;
    };

    dockerSocket.enable = true; # for docker-compose
  };

  # Allow for running containers of other platforms.
  boot.binfmt.preferStaticEmulators = true;
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  environment.systemPackages = with pkgs; [ docker-compose ];

  # Rootless podman
  boot.kernel.sysctl."kernel.unprivileged_userns_clone" = lib.mkForce 1;

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
