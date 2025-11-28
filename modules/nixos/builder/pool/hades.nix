{ config
, lib
, hostName
, ...
}:

{
  nix.settings.substituters = lib.mkAfter [ "http://atlas:15000" ];
  nix.settings.trusted-public-keys = [ "hades:j8p0UaxcNZ2UamilDop0OUYpwIfY4zFJROdo2kKib9Y=" ];

  nix.buildMachines = [
    {
      protocol = "ssh-ng";
      sshUser = "kat";
      hostName = "hades";
      systems = [ "x86_64-linux" "aarch64-linux" ];
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      sshKey = config.sops.secrets."ssh/${hostName}".path;
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUhaSVMvMTRSS0ZSQVlIM3pVam90dk5qdmtJTGF4K0kvL2orS2EyaFcwSzkgcm9vdEBoYWRlcwo=";
    }
  ];
}
