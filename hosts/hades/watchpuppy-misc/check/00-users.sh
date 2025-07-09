#!/usr/bin/env bash
set -euo pipefail

users="$(w -h | grep -v systemd | wc -l)"

if [ "$users" -eq 0 ]; then
  exit 42
fi
