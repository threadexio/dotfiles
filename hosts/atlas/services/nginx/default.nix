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

    virtualHosts = {
      "q0.ddns.net" = {
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
        enableACME = true;

        locations = {
          "/" = {
            root = ./www/public;
            index = "index.html";
            tryFiles = "$uri $uri/ =404";
          };

          "/git/" = with config.services.gitea.settings.server; {
            proxyPass = "http://${HTTP_ADDR}:${toString HTTP_PORT}/";
            extraConfig = ''
              client_max_body_size 512M;
              rewrite ^/git(/.*) $1 break;
            '';
          };

          "/vault/" = with config.services.vaultwarden.config; {
            proxyPass = "http://${ROCKET_ADDRESS}:${toString ROCKET_PORT}";
          };
        };
      };
    };
  };

  systemd.services.nginx =
    let
      dependencies = [
        "gitea.service"
        "vaultwarden.service"
      ];
    in
    {
      wants = dependencies;
      after = dependencies;
    };

  security.acme = {
    acceptTerms = true;
    defaults.email = "pzarganitis@gmail.com";
  };
}
