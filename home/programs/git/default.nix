{ ... }: {
  imports = [
    ../gpg
  ];

  programs.git = {
    enable = true;

    signing = {
      # GnuPG will decide based on the author's email.
      key = "D4751508457E41726D4A4F247FAD5F3A3702647C";
      signByDefault = true;
    };

    userName = "threadexio";
    userEmail = "pzarganitis@gmail.com";
  };
}
