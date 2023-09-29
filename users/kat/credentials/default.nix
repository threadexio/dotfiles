{ ... }: {
  programs.ssh = {
    # SSH complains about bad permissions on the config file.
    enable = false;

    /*
      compression = true;
      matchBlocks = {
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/github";
      };
      };
    */
  };

  programs.gpg = {
    enable = true;

    mutableKeys = true;
    mutableTrust = true;

    publicKeys = [
      {
        trust = "ultimate";
        source = ./${"pzarganitis_gmail.com.public.asc"};
      }
    ];

    settings = {
      keyserver = "hkps://keys.openpgp.org";
    };
  };

  services.gpg-agent = {
    enable = true;

    enableZshIntegration = true;
    grabKeyboardAndMouse = true;
    pinentryFlavor = "gnome3";
  };
}
