{ inputs
, config
, pkgs
, lib
, ...
}:

{
  imports = [
    ../../../../modules/nixos/services/minecraft-server
  ];

  services.minecraft-server = {
    enable = true;
    package = pkgs.fabricServers.fabric-1_21_4;

    eula = true;
    jvmOpts = "-Xmx4096M -Xms2048M";

    mods =
      let
        inherit (config.services.minecraft-server.package) version;
      in
      [
        (pkgs.fetchurl {
          pname = "architectury";
          inherit version;
          url = "https://cdn.modrinth.com/data/lhGA9TYQ/versions/73nlw3WM/architectury-15.0.3-fabric.jar";
          hash = "sha256-nhH4HueGQBom3khql5hodVmlMp/sPNQV6U+jw5WDUvM=";
        })
        (pkgs.fetchurl {
          pname = "cloth-config";
          inherit version;
          url = "https://cdn.modrinth.com/data/9s6osm5g/versions/TJ6o2sr4/cloth-config-17.0.144-fabric.jar";
          hash = "sha256-H9oMSonU8HXlGz61VwpJEocGVtJS2AbqMJHSu8Bngeo=";
        })
        (pkgs.fetchurl {
          pname = "fabric-api";
          inherit version;
          url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/p96k10UR/fabric-api-0.119.4%2B1.21.4.jar";
          hash = "sha256-0YO6y4RRZ/CSZML5AyK37P/ogm3r2m9g5ZeIkmS+9K8=";
        })
        (pkgs.fetchurl {
          pname = "fabric-language-kotlin";
          inherit version;
          url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/Y91MRWtG/fabric-language-kotlin-1.13.5%2Bkotlin.2.2.10.jar";
          hash = "sha256-waj7tOTvanIRze9wQxeVpObUU/5XE/sSweYnnWSqrYQ=";
        })
        (pkgs.fetchurl {
          pname = "ferritecore";
          inherit version;
          url = "https://cdn.modrinth.com/data/uXXizFIs/versions/IPM0JlHd/ferritecore-7.1.1-fabric.jar";
          hash = "sha256-DdXpIDVSAk445zoPW0aoLrZvAxiyMonGhCsmhmMnSnk=";
        })
        (pkgs.fetchurl {
          pname = "lithium";
          inherit version;
          url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/u8pHPXJl/lithium-fabric-0.15.3%2Bmc1.21.4.jar";
          hash = "sha256-FTiR6NaYj+3/pQmIUacloTfD5coEqJqN9An+sxNiPrQ=";
        })
        (pkgs.fetchurl {
          pname = "RoughlyEnoughItems";
          inherit version;
          url = "https://cdn.modrinth.com/data/nfn13YXA/versions/C4edQN1w/RoughlyEnoughItems-18.0.808-fabric.jar";
          hash = "sha256-r+IkbTXwoaM+zuK3QISWcrJzqtb92ffGs1xjXJK2uXU=";
        })
        (pkgs.fetchurl {
          pname = "silk-all";
          inherit version;
          url = "https://cdn.modrinth.com/data/aTaCgKLW/versions/7WFi2tUG/silk-all-1.11.0.jar";
          hash = "sha256-bM+vZFYMPwXeWN5lPsNS1NsYbWbw1JXxawV+fJiKYGg=";
        })
        (pkgs.fetchurl {
          pname = "skinrestorer";
          inherit version;
          url = "https://cdn.modrinth.com/data/ghrZDhGW/versions/tAfs8lH0/skinrestorer-2.4.3%2B1.21-fabric.jar";
          hash = "sha256-TACR5KAOQWeA/D3xnK5S8aGXOVBVrcZZaQO7qulZkIo=";
        })
        (pkgs.fetchurl {
          pname = "syncmatica";
          inherit version;
          url = "https://cdn.modrinth.com/data/bfneejKo/versions/PpQoWWxV/syncmatica-fabric-1.21.4-0.3.14-sakura.4.jar";
          hash = "sha256-yfzaT9bJQz2FoMO9e0JlvKYRKcA2803RlQZsNFEeKu0=";
        })
        (pkgs.fetchurl {
          pname = "veinminer";
          inherit version;
          url = "https://cdn.modrinth.com/data/OhduvhIc/versions/VDHlG2JK/veinminer-fabric-2.4.2.jar";
          hash = "sha256-gNr71pHPAlupLQUxfEW0al1tTRo7qpesHreyy1bRk0I=";
        })
        (pkgs.fetchurl {
          pname = "worldedit";
          inherit version;
          url = "https://cdn.modrinth.com/data/1u6JkXh5/versions/bxlboAan/worldedit-mod-7.3.11.jar";
          hash = "sha256-V+8eKjmJ9N1o4AGTYVpvRV1mHUG2cD8Ghxo3P7S9FmU=";
        })
      ];
  };

  systemd.services.minecraft-server = {
    wantedBy = lib.mkForce [ ];

    serviceConfig = {
      ExecStartPost =
        let
          wait-tcp = pkgs.writeShellScriptBin "wait-tcp" (with pkgs; ''
            while ! ${libressl.nc}/bin/nc -z "''${1:?missing host}" "''${2:?missing port}" >/dev/null 2>&1; do
              ${coreutils}/bin/sleep 1
            done
          '');
        in
        [
          "${wait-tcp}/bin/wait-tcp 127.0.0.1 50000"
        ];

      ExecStopPost = [
        "+${pkgs.btrfs-utils}/bin/btrfs-snapshot ${config.services.minecraft-server.dataDir}"
      ];

      PrivateTmp = true;
      PrivateNetwork = true;
    };
  };

  systemd.sockets.proxy-minecraft-server = {
    description = "Minecraft Server systemd socket";
    listenStreams = [ "25565" ];
    wantedBy = [ "sockets.target" ];
  };

  systemd.services.proxy-minecraft-server = {
    description = "Minecraft Server systemd socket proxy";
    requires = [ "proxy-minecraft-server.socket" "minecraft-server.service" ];
    after = [ "proxy-minecraft-server.socket" "minecraft-server.service" ];

    unitConfig = {
      JoinsNamespaceOf = "minecraft-server.service";
    };

    serviceConfig = {
      Type = "notify";
      ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd 127.0.0.1:50000";
      PrivateTmp = true;
      PrivateNetwork = true;
    };
  };

  services.sleep-on-inactivity.check.tcp.ports = [ 25565 ];

  nixpkgs.overlays = [
    inputs.fabric-servers.overlays.default
  ];
}
