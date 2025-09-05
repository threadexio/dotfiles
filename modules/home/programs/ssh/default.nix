{ config
, ...
}:

let
  sshPath = "${config.home.homeDirectory}/.ssh";
in

{
  programs.ssh = {
    enable = true;

    enableDefaultConfig = false;

    includes = [ "${sshPath}/config.local" ];

    matchBlocks = {
      "*" = {
        # Modern terminals like Alacritty and Kitty set their own $TERM. Most
        # machines do not contain these terminfo entries and as such many interactive
        # programs fail to work correctly.
        setEnv.TERM = "xterm-256color";
      };

      "github.com" = {
        user = "git";
        identityFile = "${sshPath}/github";
      };

      "172.0.0.*" = {
        user = "user";
        extraOptions.StrictHostKeyChecking = "no";
        extraOptions.UserKnownHostsFile = "/dev/null";
      };

      "172.1.0.*" = {
        user = "user";
        extraOptions.StrictHostKeyChecking = "no";
        extraOptions.UserKnownHostsFile = "/dev/null";
      };
    };
  };
}
