#!/usr/bin/env bash
set -eu -o pipefail

PKG_PREFIX_DIR="@PACKAGE_PREFIX@"
PKG_DATA_DIR="${PKG_PREFIX_DIR}/share/hackvm"

IMAGE="localhost/hackvm"

RESET="\x1b[0m"
BOLD="\x1b[1m"
DIM="\x1b[2m"
RED="\x1b[31m"
GREEN="\x1b[32m"
YELLOW="\x1b[33m"

info() {
  printf "[$BOLD$GREEN+$RESET] %s\n" "$*" >&2
}

warn() {
  printf "[$BOLD$YELLOW!$RESET] %s\n" "$*" >&2
}

error() {
  printf "[$BOLD$RED*$RESET] %s\n" "$*" >&2
}

die() {
  error "$@"
  exit 1
}

sha256() {
  sha256sum - | cut -d' ' -f1
}

detect_oci_runtime() {
  if command -v docker >/dev/null; then
    echo "docker"
  elif command -v podman >/dev/null; then
    echo "podman"
  else
    die "cannot find a compatible OCI runtime"
  fi
}

RUNTIME="$(detect_oci_runtime)"

docker() {
  command $RUNTIME "$@"
}

get_default_vm_name() {
  echo "hackvm.$(basename "$PWD")"
}

build_image() {
  local dockerfile="$PKG_DATA_DIR/Dockerfile"
  local ts
  local tag

  ts="$(date --rfc-3339=date)"
  tag="$( (cat "$dockerfile"; echo "$ts") | sha256 )"
  
  docker build \
    -t "$IMAGE:$tag" -t "$IMAGE:latest" \
    -f "$dockerfile" "$PKG_DATA_DIR"
}

run_vm() {
  local name="${1:-$(get_default_vm_name)}"
  local tag="${2:-latest}"

  if ! docker image exists "$IMAGE"; then
    warn "hackvm image not found. building now..."
    build_image
  fi

  if docker container exists "$name"; then
    exec docker container start -ai "$name"
  else
    local extra_args=""

    if [ "$(docker info -f "{{.Host.RemoteSocket.Exists}}")" = true ]; then
      local socket_path
      socket_path="$(docker info -f "{{.Host.RemoteSocket.Path}}")"

      extra_args="$extra_args -v $socket_path:/run/hackvm/oci.sock"
    fi

    if [ -d "/nix" ]; then
      extra_args="$extra_args -v /nix:/nix:ro"
    fi
  
    # shellcheck disable=SC2086,SC2090
    exec docker container run -it --name "$name" \
      --network host --privileged \
      -v "$PWD":/shared \
      -v "$PWD":"$PWD" \
      $extra_args \
      "$IMAGE:$tag"
  fi
}

destroy_vm() {
  local name="${1:-$(get_default_vm_name)}"

  if docker container exists "$name"; then
    docker container rm "$name" >/dev/null
  fi
}

main() {
  if [ $# -lt 1 ]; then
    run_vm "$@"
  fi

  local cmd="$1"
  shift

  case "$cmd" in
    run) run_vm "$@" ;;
    build) build_image;;
    destroy) destroy_vm "$@" ;;
    *help) usage;;
    *)
      error "unknown command"
      usage
      ;;
  esac
}

usage() {
  printf "usage: $BOLD%s$RESET [command] [args]...\n" "$0"
  printf "\n"
  printf "\n"
  printf "commands:\n"
  printf "\n"

  x() {
    printf "  $BOLD%-10s$RESET $DIM%-20s$RESET   %s\n" "$@"
  }

  x "run" "[name] [image]" "Run a hackvm. (default)"
  x "build" "" "(Re)Build the hackvm image."
  x "destroy" "[name]" "Destroy the hackvm."

  unset -f x
}

main "$@"
