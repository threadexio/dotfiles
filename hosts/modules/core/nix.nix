{ pkgs
, ...
}:

{
  nix = {
    package = pkgs.nixVersions.latest;

    distributedBuilds = true;
    settings.builders-use-substitutes = true;

    settings.substituters = [
      "http://hades:5000"
    ];

    settings.trusted-public-keys = [
      "hades:j8p0UaxcNZ2UamilDop0OUYpwIfY4zFJROdo2kKib9Y="
    ];

    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.trusted-users = [ "root" "@wheel" ];

    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  nixpkgs.config.allowUnfree = true;
}
