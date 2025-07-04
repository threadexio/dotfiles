#!/usr/bin/env bash
set -eu

systemctl stop minecraft-server.service
btrfs-snapshot /var/lib/minecraft
