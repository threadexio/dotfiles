{ config
, ...
}:

{
  networking = {
    nftables.enable = true;
    firewall.enable = false;
  };

  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };

  # DNS
  networking.nameservers = [
    "1.1.1.1#one.one.one.one"
    "9.9.9.9#dns.quad9.net"
  ];
  services.resolved = {
    enable = true;
    dnssec = "true";
    llmnr = "resolve";
    dnsovertls = "true";
  };

  # systemd-resolved handles mDNS
  services.avahi.enable = false;

  services.openssh = {
    settings = {
      UseDns = false;
      PermitRootLogin = "prohibit-password";
    };

    hostKeys =
      let
        hostKeyFromSops = type: {
          path = config.sops.secrets."ssh/host_${type}_key".path;
          inherit type;
        };
      in
      [
        (hostKeyFromSops "ed25519")
        (hostKeyFromSops "rsa")
      ];
  };

  sops.secrets = {
    "ssh/host_ed25519_key" = { };
    "ssh/host_rsa_key" = { };
  };
}
