{ pkgs, ... }: {
  nix = {
    package = pkgs.nixVersions.latest;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
    };

    /*
      gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      };
    */

    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  nixpkgs.config.allowUnfree = true;
}
