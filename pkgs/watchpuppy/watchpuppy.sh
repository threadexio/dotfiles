#!/usr/bin/env bash
set -eu -o pipefail

is_user_logged_in() {
  local user="${1:?expected user}"
  who | cut -d' ' -f1 | grep -qFx "${user}"
}

usage() {
  echo "usage: $0 -u <user> -t <duration>"
  exit 1
}

main() {
  local user
  local timeout

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

    if ! is_user_logged_in "$user"; then
      systemctl suspend -i
    fi
  done
}

main "$@"
