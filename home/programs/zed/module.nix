{ config, pkgs, lib, ... }:
let
  cfg = config.custom.programs.zed;
in
{
  options = {
    custom.programs.zed = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to install the zed editor.
        '';
      };

      package = lib.mkOption {
        default = pkgs.zed-editor;
        type = lib.types.package;
        description = ''
          Which package to use.
        '';
      };

      extraPackages = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.package;
        description = ''
          Extra packages available to zed.
        '';
      };

      settings = lib.mkOption {
        default = { };
        type = lib.types.attrs;
        description = ''
          zed editor settings.
        '';
      };

      keymap = lib.mkOption {
        default = { };
        type = lib.types.attrs;
        description = ''
          zed editor keymap.
        '';
      };
    };
  };

  config =
    let
      zedConfigDirPath = "${config.xdg.configHome}/zed";
      zedSettingsPath = "${zedConfigDirPath}/settings.json";
      zedKeymapPath = "${zedConfigDirPath}/keymap.json";
    in
    lib.mkIf cfg.enable {
      home.packages = [ cfg.package ];

      home.file."${zedSettingsPath}".text = builtins.toJSON cfg.settings;
      home.file."${zedKeymapPath}".text = builtins.toJSON cfg.keymap;
    };
}
