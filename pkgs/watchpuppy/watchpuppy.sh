#!/usr/bin/env bash
set -eu -o pipefail

usage() {
  echo "usage: $0 -u <user> -t <duration>"
  exit 1
}

local_logins() {
  who | cut -d' ' -f1 | grep -qFx "${user}"
}

active_ssh_sessions() {
  pgrep -ai sshd-session | grep -q "$user"
}

should_sleep() {
  (! local_logins) && (! active_ssh_sessions)
}

main() {
  while getopts ":u:t:" opt; do
    case "$opt" in
      u) user="$OPTARG";;
      t) timeout="$OPTARG";;
      *)
        echo "error: unknown option '-$OPTARG'"
        usage
    esac
  done
  shift $((OPTIND-1))

  if [ -z "${user+x}" ] || [ -z "${timeout+x}" ]; then
    echo "error: missing either -u or -t"
    usage
  fi

  while true; do
    sleep "${timeout}"

    if should_sleep; then
      echo "Putting the system to sleep..."
      systemctl suspend -i
    fi
  done
}

main "$@"
