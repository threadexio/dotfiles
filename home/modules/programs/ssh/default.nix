{ config
, ...
}:

let
  sshPath = "${config.home.homeDirectory}/.ssh";
in

{
  programs.ssh = {
    enable = true;

    includes = [ "${sshPath}/config.local" ];

    matchBlocks = {
      "github.com" = {
        user = "git";
      };

      "172.0.0.*" = {
        user = "user";
        extraOptions.StrictHostKeyChecking = "no";
        extraOptions.UserKnownHostsFile = "/dev/null";
      };
    };
  };
}
