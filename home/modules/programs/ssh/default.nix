{ ... }: {
  programs.ssh = {
    enable = false;

    compression = true;
  };
}
