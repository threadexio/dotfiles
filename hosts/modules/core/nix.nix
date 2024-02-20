{ pkgs, ... }: {
  nix = {
    package = pkgs.nixUnstable;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
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
