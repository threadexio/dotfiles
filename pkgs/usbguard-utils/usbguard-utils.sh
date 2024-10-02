#!/usr/bin/env bash
set -eu -o pipefail

cmd_enable_usbguard() {
    pkexec usbguard set-parameter ImplicitPolicyTarget block
}

cmd_disable_usbguard() {
    pkexec usbguard set-parameter ImplicitPolicyTarget allow
}

usage() {
    echo "usage: $0 [command]"
    echo
    echo "commands:"
    echo "  enable-usbguard    Enable usbguard after disabling it"
    echo "  disable-usbguard   Disable usbguard temporarily (does not persist across reboots)"
    exit 0
}

run_command() {
    local cmd="$1"
    shift

    case "$cmd" in
        "enable-usbguard") cmd_enable_usbguard "$@";;
        "disable-usbguard") cmd_disable_usbguard "$@";;
        *) usage;;
    esac
}

main() {

    if [ "$0" == "usbguard-utils" ]; then
        if [ "$#" -lt 1 ]; then
            usage
        fi

        run_command "$@"
    else
        local name
        name="$(basename "$0")"

        run_command "$name" "$@"
    fi
}

main "$@"
