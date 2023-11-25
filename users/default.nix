{ inputs }:
let
  mkUser =
    { name
    , homeConfig
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
      home-manager.users.${name} = homeConfig;
    } // (extraSystemConfig args);
in
{
  kat = mkUser {
    name = "kat";
    homeConfig = import ./kat;
    extraUserConfig = { pkgs, ... }: {
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "networkmanager" "libvirtd" "podman" "wireshark" ];

      # Rootless podman containers
      subUidRanges = [{ startUid = 100000; count = 65536; }];
      subGidRanges = [{ startGid = 100000; count = 65536; }];
    };
    extraSystemConfig = { pkgs, ... }: {
      environment.pathsToLink = [ "/share/zsh" ];
      programs.zsh.enable = true;

      programs.wireshark.enable = true;
      environment.systemPackages = with pkgs; [ wireshark ];
    };
  };

  io = mkUser {
    name = "io";
    homeConfig = import ./io;
    extraUserConfig = { pkgs, ... }: {
      initialPassword = "password";
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "networkmanager" "libvirtd" "podman" ];

      # Rootless podman containers
      subUidRanges = [{ startUid = 100000; count = 65536; }];
      subGidRanges = [{ startGid = 100000; count = 65536; }];
    };
    extraSystemConfig = { pkgs, ... }: {
      environment.pathsToLink = [ "/share/zsh" ];
      programs.zsh.enable = true;
    };
  };

}
