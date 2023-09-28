{ inputs, users }:
let
  mkSystem =
    { hostname
    , system
    , users ? [ ]
    }:
    let
      inherit (inputs.nixpkgs) lib;
    in
    lib.nixosSystem {
      inherit system;

      modules = [
        ./${hostname}

        { networking.hostName = lib.mkForce hostname; }
        inputs.hm.nixosModules.home-manager
      ] ++ users;
    };
in
{
  redstarOS = mkSystem {
    hostname = "redstarOS";
    system = "x86_64-linux";
    users = [ users.kat ];
  };

  testVM = mkSystem {
    hostname = "testVM";
    system = "x86_64-linux";
  };
}
