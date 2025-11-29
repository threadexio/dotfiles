{ config
, lib
, ...
}:

let
  cfg = config.services.minecraft-server;
  inherit (cfg) modsDir;

  user = config.systemd.services."minecraft-server".serviceConfig.User;
  group = user;
in

{
  options.services.minecraft-server = {
    mods = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression ''
        [
          (pkgs.fetchurl {
            pname = "test-mod";
            url = "https://example.com/test-mod.jar";
            hash = "sha256-0000000000000000000000000000000000000000000000000000000000000000";
          })
        ]
      '';
      description = ''
        Mods to run the server with. Must be using a compatible package.
      '';
    };

    modsDir = lib.mkOption {
      type = lib.types.path;
      default = "${cfg.dataDir}/mods";
      defaultText = lib.literalExpression "\${services.minecraft-server.dataDir}/mods";
      example = "/var/lib/minecraft/mods";
      description = ''
        Directory where mods should be placed in. Should be left at the default
        value most of the time.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.settings."10-minecraft-server-mods" = {
      "${modsDir}".d = {
        inherit user group;
        mode = "0755";
      };
    } // (lib.genAttrs' cfg.mods

      (mod:
        let
          name = mod.name or (builtins.baseNameOf (toString mod));
        in
        lib.nameValuePair
          "${modsDir}/${name}.jar"
          {
            L = {
              argument = toString mod;
            };
          }
      )
    );
  };
}
