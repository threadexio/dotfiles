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
        max-attempts = 10;
        retry-delay = 5;
        retry-factor = 1.1;
      }

      # Nix Binary Cache
      {
        from = "0.0.0.0:15000";
        to = "10.0.0.17:5000";
        wait-for = 10;
        max-attempts = 10;
        retry-delay = 5;
        retry-factor = 1.1;
      }

      # Minecraft Server
      {
        from = "0.0.0.0:25565";
        to = "10.0.0.17:25565";
        wait-for = 10;
        max-attempts = 20;
        retry-delay = 5;
        retry-factor = 1.5;
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [
    10022
    15000
    25565
  ];
}
