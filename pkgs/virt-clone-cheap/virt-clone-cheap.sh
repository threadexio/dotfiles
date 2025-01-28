#!/usr/bin/env bash
set -eu

LIBVIRT_IMAGES=/var/lib/libvirt/images

BOLD="\033[1m"
RESET="\033[0m"

run() {
  printf "${BOLD}=> %s${RESET}\n" "$*"
  "$@"
}

main() {
  local src="${1:?expected source domain name}"
  local dst="${2:?expected cloned domain name}"
  local fmt="${3:-qcow2}"

  local src_disk="$LIBVIRT_IMAGES/$src.$fmt"
  local dst_disk="$LIBVIRT_IMAGES/$dst.$fmt"

  run cp --reflink=always "$src_disk" "$dst_disk"
  run virt-clone --original "$src" --name "$dst" --file "$dst_disk" --skip-copy vda
  run virt-xml "$dst" --edit target=vda --disk="$dst_disk"
}

main "$@"
