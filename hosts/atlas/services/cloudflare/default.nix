{ ...
}:

{
  imports = [
    ./dns.nix
  ];

  sops.secrets = {
    "cloudflare_api_token".owner = "cloudflare";
  };

  users.users.cloudflare = {
    description = "Cloudflare";
    home = "/var/empty";
    isSystemUser = true;
    group = "cloudflare";
  };
  users.groups.cloudflare = {};
}
