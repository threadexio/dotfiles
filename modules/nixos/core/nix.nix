{ pkgs
, ...
}:

{
  nix = {
    package = pkgs.nixVersions.latest;

    distributedBuilds = true;

    settings = {
      builders-use-substitutes = true;

      trusted-public-keys = [
        "hades:j8p0UaxcNZ2UamilDop0OUYpwIfY4zFJROdo2kKib9Y="
      ];

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
