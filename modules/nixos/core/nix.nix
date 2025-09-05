{ pkgs
, ...
}:

{
  nix = {
    package = pkgs.nixVersions.latest;

    distributedBuilds = true;

    settings = {
      builders-use-substitutes = true;

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      trusted-users = [
        "root"
        "@wheel"
      ];

      allowed-users = [ "@wheel" ];
    };
  };

  nixpkgs.config.allowUnfree = true;
}
