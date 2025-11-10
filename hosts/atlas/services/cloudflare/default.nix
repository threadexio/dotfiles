{ config
, pkgs
, ...
}:

let
  cloudflare-dns = pkgs.writeShellApplication {
    name = "cloudflare-dns";

    runtimeInputs = with pkgs; [
      curl
      jq
    ];

    text = ''
function curl {
  # shellcheck disable=SC2086
  command curl ''${CURL_OPTS:-} "$@" 2>/dev/null
}

function cached {
  local name="''${1:?missing name}"
  local value="''${2:?missing value}"

  local old

  if [ ! -f "$name" ]; then
    echo "$value" | tee "$name"
    return 0
  fi

  old="$(cat "$name")"
  if [ "$old" == "$value" ]; then
    echo "$value"
    return 1
  else
    echo "$value" | tee "$name"
    return 0
  fi 
}

###############################################################################

function ipv4 {
  if [ -z "''${_IPV4:-}" ]; then
    _IPV4="$(curl https://ifconfig.me)"
  fi

  echo "$_IPV4"
}

###############################################################################

function cf_request {
  curl -H "Authorization: Bearer $CLOUDFLARE_TOKEN" "$@"
}

function zone_id_from_domain {
  local domain="''${1:?missing domain}"

  cf_request https://api.cloudflare.com/client/v4/zones \
    | jq -r ".result[] | select(.name==\"$domain\") .id"
}

function list_dns_records {
  local zone_id="''${1:?missing zone id}"

  cf_request "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records" \
    | jq -r "(.result[] | [.id, .name, .type, .content, .proxied, .ttl]) | @tsv"
}

function update_dns_record {
  local zone_id="''${1:?missing zone id}"
  local id="''${2:?missing id}"
  local name="''${3:?missing name}"
  local type="''${4:?missing type}"
  local content="''${5:?missing content}"
  local proxied="''${6:?missing proxied}"
  local ttl="''${7:?missing ttl}"

  cf_request "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$id" \
    -X PATCH \
    -H 'Content-Type: application/json' \
    -d "{
  \"name\": \"$name\",
  \"ttl\": $ttl,
  \"type\": \"$type\",
  \"comment\": \"Domain verification record\",
  \"content\": \"$content\",
  \"proxied\": $proxied
}"
}

###############################################################################

function main {
  local domain

  local flag
  while getopts "d:t:" flag; do
    case "$flag" in
      d) domain="$OPTARG";;
      t) CLOUDFLARE_TOKEN="$(cat "$OPTARG")";;
      *)
        echo "unknown flag $flag"
        exit 1
    esac
  done

  local ipv4
  if ! ipv4="$(cached last_ipv4 "$(ipv4)")"; then
    exit 0
  fi

  local zone_id
  zone_id="$(zone_id_from_domain "$domain")"

  local id name type content proxied ttl
  list_dns_records "$zone_id" | while read -r id name type content proxied ttl; do
    case "$type" in
      A)
        update_dns_record "$zone_id" "$id" "$name" "$type" "$ipv4" "$proxied" "$ttl"
        ;;

      *) ;;
    esac
  done
}

main "$@"
'';
  };
in

{
  sops.secrets = {
    "cloudflare_api_token" = {
      owner = "cloudflare-dns";
      restartUnits = [ "cloudflare-dns.service" ];
    };
  };

  users.users.cloudflare-dns = {
    description = "Cloudflare DNS";
    home = "/var/empty";
    isSystemUser = true;
    group = "cloudflare-dns";
  };
  users.groups.cloudflare-dns = {};

  systemd.services.cloudflare-dns = {
    description = "Cloudflare DNS";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = false;
      ExecStart = "${cloudflare-dns}/bin/cloudflare-dns -t ${config.sops.secrets.cloudflare_api_token.path} -d 31c0.org";
      User = "cloudflare-dns";
      UMask = 0077;
      StateDirectory = "cloudflare-dns";
      StateDirectoryMode = "0700";
      WorkingDirectory = "/var/lib/cloudflare-dns";
      StandardInput = "null";
      StandardOutput = "syslog";
      StandardError = "syslog";
      TimeoutSec = 120;
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/cloudflare-dns 770 cloudflare-dns cloudflare-dns -"
  ];

  systemd.timers.cloudflare-dns = {
    description = "Cloudflare DNS";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "*-*-* 02:00:00";
      Persistent = true;
    };
  };
}
