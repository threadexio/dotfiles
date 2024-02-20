{ ... }: {
  programs.ssh = {
    enable = true;

    compression = true;
    matchBlocks = {
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/github";
      };
    };
  };

  home.file.".ssh/authorized_keys" = {
    enable = true;
    source = ./authorized_keys;
  };
}
