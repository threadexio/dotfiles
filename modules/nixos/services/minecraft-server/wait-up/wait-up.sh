#!/usr/bin/env bash
set -eu -o pipefail

ATTEMPTS=120
DELAY=1

function var {
  if [ -r ./server.properties ]; then
    sed -nr "s%^$1=(.*)$%\1%p" < ./server.properties
  else
    echo ''
  fi
}

port="$(var server-port)"

if [ -z "$port" ]; then
  exit 0
fi

attempts=0
while ! nc -z 127.0.0.1 "$port" >/dev/null; do
  sleep "$DELAY"

  if [ "$attempts" -eq "$ATTEMPTS" ]; then
    exit 1
  fi

  attempts=$((attempts+1))
done

