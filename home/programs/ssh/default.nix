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
}
