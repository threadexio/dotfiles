{ ... }: {
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };

  # DNS
  networking.nameservers = [ "9.9.9.9#dns.quad9.net" "1.1.1.1#one.one.one.one" ];
  services.resolved = {
    enable = true;
    dnssec = "true";
    llmnr = "resolve";
    dnsovertls = "true";
  };

  # systemd-resolved handles mDNS
  services.avahi.enable = false;

  # Remote access
  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--accept-routes" ];
  };

  services.openssh = {
    enable = true;
    settings = {
      UseDns = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  # Misc
  networking = {
    nftables.enable = true;
    firewall.enable = false;
  };
}
