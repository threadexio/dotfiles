#!/usr/bin/env bash
set -eu

count="$(ss --no-header -tn | awk '{print $4}' | grep -e 50000 | wc -l)"

if [ "$count" -eq 0 ]; then
  exit 42
fi
