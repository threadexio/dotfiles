{ inputs
, homes
, systems
, overlays
, specialArgs
, ...
}:
with builtins;

let
  inherit (inputs.nixpkgs) lib;

  nixosSystem =
    { modules
    , homes ? [ ]
    ,
    }:
    let
      nixosHomeModules = (
        if length homes == 0 then
          [ ]
        else
          [
            inputs.hm.nixosModules.default
            {
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.useGlobalPkgs = true;
              home-manager.users.kat.imports = lib.lists.flatten (map (home: home.modules) homes);
            }
          ]
      );
    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit specialArgs;

      modules = [
        {
          nixpkgs.overlays = overlays;
          nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "discord" ];
        }
      ]
      ++ modules
      ++ nixosHomeModules;
    };
in

{
  _module.args.systems = {
    ares = {
      modules = [ ./ares ];
      homes = [ homes.ares ];
    };

    hades = {
      modules = [ ./hades ];
      homes = [ homes.hades ];
    };
  };

  flake.nixosConfigurations = mapAttrs (_: nixosSystem) systems;
}
