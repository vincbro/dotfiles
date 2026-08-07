#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 || ! $1 =~ ^([1-9]|10)$ ]]; then
    printf 'usage: %s <tab-number: 1-10>\n' "${0##*/}" >&2
    exit 2
fi

workspace_id=${HERDR_ACTIVE_WORKSPACE_ID:-${HERDR_WORKSPACE_ID:-}}
herdr_bin=${HERDR_BIN_PATH:-herdr}

if [[ -z "$workspace_id" ]]; then
    exit 0
fi

tabs=$("$herdr_bin" tab list --workspace "$workspace_id")

tab_id=$(
    jq -er --argjson index "$1" '
        def tab_items:
            if type == "array" then .
            elif type == "object" then
                (.result.tabs // .tabs //
                    (if (.result | type) == "array" then .result else [] end))
            else []
            end;

        tab_items[$index - 1] | (.tab_id // .id) // empty
    ' <<<"$tabs"
) || exit 0

[[ -n "$tab_id" ]] || exit 0
exec "$herdr_bin" tab focus "$tab_id"
