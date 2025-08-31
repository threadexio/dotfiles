{ ...
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

  services.openssh.settings = {
    UseDns = false;
    PermitRootLogin = "prohibit-password";
  };
}
