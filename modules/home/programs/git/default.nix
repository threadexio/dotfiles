{ config
, nixosConfig ? null
, ...
}:

{
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

    difftastic = {
      enable = false;
      enableAsDifftool = true;
    };
  };

  programs.ssh.matchBlocks =
    let
      sshKeyPath = key: if nixosConfig == null then "${config.home.homDirectory}/.ssh/${key}" else nixosConfig.sops.secrets."ssh/${key}".path;
    in
    {
      "privategit" = {
        user = "gitea";
        hostname = "31c0.org";
        port = 2222;
        identityFile = sshKeyPath "privategit";
      };

      "github.com" = {
        user = "git";
        identityFile = sshKeyPath "github";
      };
    };
}
