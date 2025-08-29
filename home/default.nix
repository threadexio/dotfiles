{ inputs
, specialArgs
, ...
}:

let
  inherit (inputs.nixpkgs) lib;
in

{
  flake.homeConfigurations =
    let
      homeConfiguration =
        { home, system }:
        inputs.hm.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs { inherit system; };

          modules = [
            ./${home}
          ];

          extraSpecialArgs = specialArgs;
        };

      homes = [
        {
          home = "hermes";
          system = "aarch64-linux";
        }
        {
          home = "cerberus";
          system = "x86_64-linux";
        }
      ];
    in
    lib.listToAttrs (map (x: lib.nameValuePair x.home (homeConfiguration x)) homes);
}
