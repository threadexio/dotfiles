{ self
, inputs
, homes
, ...
}:

let
  nixosSystem = { modules, home }:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        { nixpkgs.overlays = [ self.overlays.packages ]; }
      
        inputs.hm.nixosModules.default
        {
          home-manager.extraSpecialArgs = { inherit self inputs; };
          home-manager.users.kat.imports = [
            { nixpkgs.overlays = [ self.overlays.packages ]; }
          ] ++home.modules;
        }
      ] ++ modules;

      specialArgs = { inherit self inputs; };
    };
in

{
  flake.nixosConfigurations = {
    ares = nixosSystem {
      modules = [ ./ares ];
      home = homes.ares;
    };

    hades = {
      modules = [ ./hades ];
      home = homes.hades;
    };
  };
}
