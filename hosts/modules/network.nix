{ ... }: {
  # Network manager
  services.avahi.enable = false;
  networking.nameservers = [ "9.9.9.9#dns.quad9.net" "1.1.1.1#one.one.one.one" ];
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };

  # DNS
  services.resolved = {
    enable = true;
    dnssec = "true";
    llmnr = "resolve";
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };

  # Remote access
  services.tailscale.enable = true;
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
