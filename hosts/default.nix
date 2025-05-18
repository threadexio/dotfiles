{ self
, inputs
, homes
, systems
, ...
}:
with builtins;

let
  lib = inputs.nixpkgs.lib;

  nixosSystem = { modules, homes ? [] }:
    let
      nixosHomeModules = (if length homes == 0 then [] else [
        inputs.hm.nixosModules.default
        {
          home-manager.extraSpecialArgs = { inherit self inputs; };
          home-manager.users.kat.imports = [
            { nixpkgs.overlays = [ self.overlays.packages ]; }
          ]
          ++ (lib.lists.flatten (map (home: home.modules) homes));
        }
      ]);
    in
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        { nixpkgs.overlays = [ self.overlays.packages ]; }
      ]
      ++ modules
      ++ nixosHomeModules;

      specialArgs = { inherit self inputs; };
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

  flake.nixosConfigurations = mapAttrs
    (_: nixosSystem)
    systems;
}
