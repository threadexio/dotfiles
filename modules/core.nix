{ config
, pkgs
, lib
, ...
}: {
  boot = {
    tmp.cleanOnBoot = true;

    loader = {
      timeout = 3;

      efi = {
        efiSysMountPoint = "/boot";
        canTouchEfiVariables = true;
      };

      systemd-boot = {
        enable = true;
        editor = false;

        extraFiles = {
          "efi/memtest86+/memtest86+.efi" = "${pkgs.memtest86plus}/memtest.efi";
          "efi/edk2-shell/shell.efi" = "${pkgs.edk2-uefi-shell}/shell.efi";
        }
        // (if config.services.fwupd.enable then
          {
            "efi/fwupd/fwupd.efi" = "${pkgs.fwupd-efi}/libexec/fwupd/efi/fwupdx64.efi";
          }
        else { });

        extraEntries = {
          "edk2-shell.conf" = ''
            title edk2-shell
            efi /efi/edk2-shell/shell.efi
          '';
          "memtest86+.conf" = ''
            title MemTest86+
            efi /efi/memtest86+/memtest86+.efi
          '';
        }
        // (if config.services.fwupd.enable then
          {
            "fwupd.conf" = ''
              title Firmware Updater
              efi /efi/fwupd/fwupd.efi
            '';
          }
        else { });
      };
    };
  };

  environment.systemPackages = with pkgs; [
    util-linux
    usbutils
    pciutils
    moreutils
    vim
    curl
    htop
    file
  ] ++ (if config.boot.loader.systemd-boot.enable then
    [ memtest86plus edk2-uefi-shell ] else [ ]);

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

    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
    };

    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = lib.mkDefault "23.05"; # Did you read the comment?
}
