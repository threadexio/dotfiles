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
        # pzarganitis@gmail.com - public key
        trust = "ultimate";
        text = ''
          -----BEGIN PGP PUBLIC KEY BLOCK-----

          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
          dcX/FGEEVA==
          =42tL
          -----END PGP PUBLIC KEY BLOCK-----
        '';
      }
    ];

    settings = {
      keyserver = "hkps://keys.openpgp.org";
    };
  };
}
