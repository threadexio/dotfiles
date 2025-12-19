{ config
, ...
}:

{
  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    upstreams = {
      gitea = with config.services.gitea.settings.server; {
        servers."${HTTP_ADDR}:${toString HTTP_PORT}" = {
          fail_timeout = "10s";
          max_fails = 5;
        };
      };

      vaultwarden = with config.services.vaultwarden.config; {
        servers."${ROCKET_ADDRESS}:${toString ROCKET_PORT}" = {
          fail_timeout = "10s";
          max_fails = 5;
        };
      };
    };

    virtualHosts = {
      "31c0.org" = {
        listen = [
          {
            addr = "0.0.0.0";
            port = 80;
            ssl = false;
          }
          {
            addr = "0.0.0.0";
            port = 443;
            ssl = true;
          }
        ];

        forceSSL = true;
        useACMEHost = "31c0.org";

        locations."/" = {
          root = ./www/public;
          index = "index.html";
          tryFiles = "$uri $uri/ =404";
        };
      };

      "git.31c0.org" = {
        listen = [
          {
            addr = "0.0.0.0";
            port = 80;
            ssl = false;
          }
          {
            addr = "0.0.0.0";
            port = 443;
            ssl = true;
          }
        ];

        forceSSL = true;
        useACMEHost = "31c0.org";

        locations."/" = {
          proxyPass = "http://gitea";
          extraConfig = ''
            client_max_body_size 512M;
          '';
        };
      };

      "vault.31c0.org" = {
        listen = [
          {
            addr = "0.0.0.0";
            port = 80;
            ssl = false;
          }
          {
            addr = "0.0.0.0";
            port = 443;
            ssl = true;
          }
        ];

        forceSSL = true;
        useACMEHost = "31c0.org";

        locations."/" = {
          proxyPass = "http://vaultwarden";
        };
      };
    };
  };

  systemd.services.nginx.wants = [
    "gitea.service"
    "vaultwarden.service"
  ];
  systemd.services.nginx.after = [
    "gitea.service"
    "vaultwarden.service"
  ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "pzarganitis@gmail.com";

    certs."31c0.org" = {
      domain = "31c0.org";
      extraDomainNames = [ "*.31c0.org" ];
      dnsProvider = "cloudflare";
      dnsPropagationCheck = true;
      credentialFiles = {
        "CLOUDFLARE_DNS_API_TOKEN_FILE" = config.sops.secrets.cloudflare_api_token.path;
      };
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
