#!/usr/bin/env bash
set -euo pipefail

users="$(who | wc -l)"

if [ "$users" -eq 0 ]; then
  exit 42
fi
