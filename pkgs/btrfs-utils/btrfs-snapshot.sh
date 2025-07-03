#!/usr/bin/env bash
set -euo pipefail

SNAPSHOTS="/.snapshots"

subvol_path="${1:?expected path to subvolume to snapshot}"

umask 077

if [ ! -d "$SNAPSHOTS" ]; then
  log "snapshots directory not found. creating..." 
  mkdir -p "$SNAPSHOTS"
fi

subvol_name="$(btrfs subvolume show "$subvol_path" | awk '$1 ~ /^Name:$/ {print $2}')"
now="$(date +%F_%R)"
base_snapshot_path="$SNAPSHOTS/$now"
snapshot_path="$base_snapshot_path/$subvol_name"

mkdir -p "$base_snapshot_path"
btrfs subvolume snapshot -r "$subvol_path" "$snapshot_path"
echo "$snapshot_path"
