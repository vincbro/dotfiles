#!/usr/bin/env bash

DIRS=(
    "$HOME/Documents/work"
    "$HOME/Documents/projects"
    "$HOME/Documents"
    "$HOME/Documents/notes"
    "$HOME"
)

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(fd . "${DIRS[@]}" --type=dir --max-depth=1 --full-path --base-directory $HOME \
        | sed "s|^$HOME/||" \
        | sk --margin 10%)

    [[ $selected ]] && selected="$HOME/$selected"
fi

[[ ! $selected ]] && exit 0

selected_name=$(basename "$selected" | tr . _)

if ! tmux has-session -t "$selected_name" 2>/dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
    tmux select-window -t "$selected_name:1"
fi

if [[ -z "$TMUX" ]]; then
    exec tmux attach-session -t "$selected_name"
else
    tmux switch-client -t "$selected_name"
fi
