{ self
, config
, pkgs
, lib
, ...
}:

let
  writeJSON = name: content:
    let
      toJSON = lib.generators.toJSON { };
      inherit (builtins) toFile;
    in
    toFile name (toJSON content);

  dnsConfig = {
    rules = [
      {
        match.name = "^31c0\.org$";
        update.content = "$file:/var/lib/cloudflare-dns/ip";
      }
      {
        match.name = "^(git|vault)\.31c0\.org$";
        update.content = "$file:/var/lib/cloudflare-dns/ip";
      }
    ];
  };
in

{
  sops.secrets = {
    "cloudflare_api_token".restartUnits = [ "cloudflare-dns.service" ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/cloudflare-dns 770 cloudflare cloudflare -"
  ];

  systemd.services.cloudflare-dns = {
    description = "Cloudflare DNS";
    after = [ "network.target" "cloudflare-dns-dynamic-ip.service" ];
    requires = [ "network.target" "cloudflare-dns-dynamic-ip.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = false;
      Environment = "CLOUDFLARE_API_TOKEN_FILE=${config.sops.secrets.cloudflare_api_token.path}";
      ExecStart = "${lib.getExe pkgs.cloudflare-dns} --config ${writeJSON "cloudflare-dns-config.json" dnsConfig} --zone-id cdcfe1ccf17614a6725e3c9da71a8eb9";
      User = "cloudflare";
      UMask = 0077;
      StateDirectory = "cloudflare-dns";
      StateDirectoryMode = "0700";
      WorkingDirectory = "/var/lib/cloudflare-dns";
      StandardInput = "null";
      StandardOutput = "syslog";
      StandardError = "syslog";
      TimeoutSec = 120;
    };

    wantedBy = [ "multi-user.target" ];
  };

  systemd.timers.cloudflare-dns = {
    description = "Cloudflare DNS";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "*-*-* 02:00:00";
      Persistent = true;
    };
  };

  systemd.services.cloudflare-dns-dynamic-ip = {
    description = "Cloudflare DNS Dynamic IP";
    after = [ "network.target" ];
    requires = [ "network.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = false;
      inherit (config.systemd.services.cloudflare-dns.serviceConfig) User UMask StateDirectory StateDirectoryMode WorkingDirectory;
      StandardInput = "null";
      StandardOutput = "syslog";
      StandardError = "syslog";
      TimeoutSec = 120;
    };

    script = ''
      ${pkgs.curl}/bin/curl -s https://ifconfig.me > ip
    '';
  };

  nixpkgs.overlays = [ self.overlays.packages ];
}
