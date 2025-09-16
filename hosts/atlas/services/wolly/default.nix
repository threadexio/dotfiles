{ inputs
, ...
}:

{
  imports = [
    inputs.wolly.nixosModules.default
  ];

  services.wolly = {
    enable = true;

    upstream = [
      {
        address = "10.0.0.17";
        mac = "54:e1:ad:d1:88:41";
        brd = "10.0.0.255";
      }
    ];

    forward = [
      # SSH
      {
        from = "0.0.0.0:10022";
        to = "10.0.0.17:22";
        wait-for = 10;
      }

      # Nix Binary Cache
      {
        from = "0.0.0.0:15000";
        to = "10.0.0.17:5000";
        wait-for = 10;
      }

      # Minecraft Server
      {
        from = "0.0.0.0:50000";
        to = "10.0.0.17:50000";
        wait-for = 10;
        max-attempts = 10;
      }
    ];
  };
}
