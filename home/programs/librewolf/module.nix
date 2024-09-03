{ config, pkgs, lib, ... }:
let
  cfg = config.custom.programs.librewolf;
in
with lib;
{
  options = {
    custom.programs.librewolf = {
      enable = mkEnableOption "install the Librewolf browser.";

      package = mkOption {
        default = pkgs.librewolf;
        type = types.package;
        description = ''
          Which package to use.
        '';
      };

      overrides = mkOption {
        default = { };
        type = types.attrs;
        example = literalExpression ''
          {
            "webgl.disabled" = false;
            "privacy.resistFingerprinting" = false;
          }
        '';
        description = mkDoc ''
          Set Librewolf's overrides in `librewolf.overrides.cfg'. See
          <https://librewolf.net/docs/settings> for supported options.
        '';
      };

      themePackage = mkOption {
        type = types.package;
        description = mdDoc ''
          Package which contains the `userChrome.css` and `userContent.css`. The output
          of the package's `chrome/` directory will be linked to the `chrome/` directory
          inside the profile.
        '';
      };
    };
  };

  config =
    let
      librewolfDir = ".librewolf";
      defaultProfile = "profile.default";
    in
    mkIf cfg.enable {
      programs.librewolf = {
        enable = true;
        package  = cfg.package;

        settings = cfg.overrides // {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
      };

      home.file."${librewolfDir}/profiles.ini".text = ''
        [Profile0]
        Name=default
        IsRelative=1
        Path=${defaultProfile}
        Default=1

        [General]
        StartWithLastProfile=1
        Version=2
      '';

      home.file."${librewolfDir}/${defaultProfile}/chrome".source = "${cfg.themePackage}/chrome";


      home.packages = [
        cfg.themePackage
      ];
    };
}
