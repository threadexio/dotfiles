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
      key = "D4751508457E41726D4A4F247FAD5F3A3702647C";
      signByDefault = true;
    };

    settings = {
      user = {
        name = "threadexio";
        email = "pzarganitis@gmail.com";
      };
    };
  };

  programs.difftastic = {
    enable = true;
    git.diffToolMode = false;
  };

  programs.ssh.matchBlocks =
    let
      sshKeyPath = key: if nixosConfig == null then "${config.home.homDirectory}/.ssh/${key}" else nixosConfig.sops.secrets."ssh/${key}".path;
    in
    {
      "privategit" = {
        user = "gitea";
        hostname = "git.31c0.org";
        port = 2222;
        identityFile = sshKeyPath "privategit";
      };

      "github.com" = {
        user = "git";
        identityFile = sshKeyPath "github";
      };
    };
}
