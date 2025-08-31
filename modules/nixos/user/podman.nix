{ config
, lib
, ...
}:

let
  hasPodman = config.virtualisation.podman.enable;
in

{
  users.users.kat = {
    extraGroups = lib.optional hasPodman "podman";

    subUidRanges = lib.optional hasPodman {
      startUid = 100000;
      count = 65536;
    };

    subGidRanges = lib.optional hasPodman {
      startGid = 100000;
      count = 65536;
    };
  };
}
