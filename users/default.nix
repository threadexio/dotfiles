{ inputs }:
let
  mkUser =
    { name
    , extraUserConfig ? { ... }: { }
    , extraSystemConfig ? { ... }: { }
    }:
    args@{ pkgs, ... }:
    let
      homeDirectory = "/home/${name}";
    in
    {
      users.users.${name} = {
        description = name;
        isNormalUser = true;

        home = homeDirectory;
        createHome = true;
        homeMode = "700";
      } // (extraUserConfig args);

      home-manager.useUserPackages = true;
      home-manager.useGlobalPkgs = true;
      home-manager.users.${name} = import ./${name};
    } // (extraSystemConfig args);
in
{
  kat = mkUser {
    name = "kat";
    extraUserConfig = { pkgs, ... }: {
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "networkmanager" "libvirtd" "podman" "wireshark" ];

      # Rootless podman containers
      subUidRanges = [{ startUid = 100000; count = 65536; }];
      subGidRanges = [{ startGid = 100000; count = 65536; }];
    };
  };
}
