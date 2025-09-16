{ config
, btrfsDataMount
, ...
}:

{
  services.gitea = {
    enable = true;

    appName = "Private Gitea Instance";

    settings = {
      session = {
        COOKIE_SECURE = true;
      };

      service = {
        DISABLE_REGISTRATION = true;
        REQUIRE_SIGNIN_VIEW = false;
        REGISTER_EMAIL_CONFIRM = false;
        ENABLE_NOTIFY_EMAIL = false;
        ALLOW_ONLY_EXTERNAL_REGISTRATION = false;
        DEFAULT_KEEP_EMAIL_PRIVATE = false;
        DEFAULT_ALLOW_CREATE_ORGANIZATION = false;
      };

      server = rec {
        ROOT_URL = "https://${DOMAIN}/git/";
        DOMAIN = "q0.ddns.net";

        HTTP_ADDR = "127.0.0.42";
        HTTP_PORT = 3000;

        DISABLE_SSH = false;
        SSH_DOMAIN = DOMAIN;
        START_SSH_SERVER = true;
        SSH_PORT = 2222;
        SSH_LISTEN_PORT = 2222;

        STATIC_URL_PREFIX = "/git";
      };
    };
  };

  fileSystems.${config.services.gitea.stateDir} = btrfsDataMount "@gitea";
}
