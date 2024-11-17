{ pkgs, ... }: {
  programs.gpg = {
    enable = true;

    mutableKeys = true;
    mutableTrust = true;

    publicKeys = [
      {
        trust = "ultimate";
        source = ./pzarganitis_gmail.com.public.asc;
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
    pinentryPackage = pkgs.pinentry-gnome3;
  };
}
