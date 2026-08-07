#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRS=(
    "$HOME/Documents/work"
    "$HOME/Documents/projects"
    "$HOME/Documents/school"
    "$HOME/Documents"
    "$HOME/Documents/notes"
    "$HOME"
)

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        printf 'herdr-session: missing required command: %s\n' "$1" >&2
        exit 1
    fi
}

list_projects() {
    local root

    for root in "${PROJECT_DIRS[@]}"; do
        [[ -d "$root" ]] || continue
        printf '%s\n' "$root"
        fd . "$root" --type directory --exact-depth 1 --absolute-path
    done
}

format_projects() {
    local project

    while IFS= read -r project; do
        if [[ "$project" == "$HOME" ]]; then
            printf '~\t%s\n' "$project"
        else
            printf '%s\t%s\n' "${project#"$HOME"/}" "$project"
        fi
    done
}

if [[ $# -gt 1 ]]; then
    printf 'usage: %s [project-directory]\n' "${0##*/}" >&2
    exit 2
fi

herdr_bin=${HERDR_BIN_PATH:-herdr}
require_command "$herdr_bin"
require_command jq

if [[ $# -eq 1 ]]; then
    selected_path=$1
else
    require_command fd
    require_command sk

    selected=$(
        list_projects |
            awk '!seen[$0]++' |
            format_projects |
            sk --delimiter $'\t' --with-nth 1 --margin 5%
    ) || exit 0

    [[ -n "$selected" ]] || exit 0
    selected_path=${selected#*$'\t'}
fi

if [[ ! -d "$selected_path" ]]; then
    printf 'herdr-session: not a directory: %s\n' "$selected_path" >&2
    exit 1
fi

# fd prints directory results with a trailing slash. Normalize the selected
# path so it matches Herdr's pane cwd and produces a non-empty workspace label.
selected_path=$(cd -- "$selected_path" && pwd -P)

panes=$("$herdr_bin" pane list)
workspace_id=$(
    jq -er --arg cwd "$selected_path" '
        first(
            .result.panes[]?
            | select(.cwd == $cwd)
            | .workspace_id
        ) // empty
    ' <<<"$panes"
) || true

if [[ -n "$workspace_id" ]]; then
    exec "$herdr_bin" workspace focus "$workspace_id"
fi

if [[ "$selected_path" == "$HOME" ]]; then
    workspace_label='~'
else
    workspace_label=${selected_path##*/}
fi

exec "$herdr_bin" workspace create \
    --cwd "$selected_path" \
    --label "$workspace_label" \
    --focus
