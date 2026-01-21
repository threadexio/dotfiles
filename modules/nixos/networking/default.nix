{ ...
}:

{
  networking.nameservers = [
    "1.1.1.1#one.one.one.one"
    "9.9.9.9#dns.quad9.net"
  ];

  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };

  services.avahi.enable = false;
  services.resolved = {
    enable = true;

    settings = {
      Resolve = {
        DNSSEC = true;
        DNSOverTLS = true;
        LLMNR = "resolve";
      };
    };
  };

  networking.nftables.enable = true;
}
