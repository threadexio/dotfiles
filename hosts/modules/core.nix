{ config
, pkgs
, lib
, ...
}: {
  boot.tmp.cleanOnBoot = true;

  environment.systemPackages = with pkgs; [
    util-linux
    usbutils
    pciutils
    moreutils
    vim
    curl
    htop
    file
  ];

  time.timeZone = "Europe/Athens";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "el_GR.UTF-8";
      LC_IDENTIFICATION = "el_GR.UTF-8";
      LC_MEASUREMENT = "el_GR.UTF-8";
      LC_MONETARY = "el_GR.UTF-8";
      LC_NAME = "el_GR.UTF-8";
      LC_NUMERIC = "el_GR.UTF-8";
      LC_PAPER = "el_GR.UTF-8";
      LC_TELEPHONE = "el_GR.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  services.printing.enable = false;

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
