#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash jq gawk
set -e
exec >&2

LIBREWOLF_DATA="${LIBREWOLF:-$HOME/.librewolf}"

get_default_librewolf_profile_name() {
    find "$LIBREWOLF_DATA" -maxdepth 1 -type d -name '*.default' -printf "%f"
}

prefs_js_to_kv() {
    sed -ne 's/^.*("\(.*\)", \(.*\));$/"\1" \2/gp' | sort -d
}

prefs_kv_to_json() {
    awk '
        BEGIN { print "{" }
        {
            key=$1
            $1=""; print key ":", $0 ","
        }
        END { print "}" }
    ' | sed -z 's/,\(\n}\)/\1/g' | jq
}

# usage: dump-prefs.sh [output prefs.json] [librewolf profile]
main() {
    local prefs_json_out="${1:-./prefs.json}"
    local profile="${2:-$(get_default_librewolf_profile_name)}"
    shift 2 || true

    echo "using prefs.js from '$profile'"

    echo "writing prefs to '$prefs_json_out'"
    cat "$LIBREWOLF_DATA/$profile/prefs.js" \
        | prefs_js_to_kv \
        | prefs_kv_to_json \
        >"$prefs_json_out"
}

main "$@"
