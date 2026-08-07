#!/bin/zsh

if [[ -n "${GHOSTTY_QUICK_TERMINAL:-}" ]]; then
    export HERDR_ENV=1
fi

exec /bin/zsh -l "$@"
