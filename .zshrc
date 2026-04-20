eval "$(zoxide init zsh)"
alias cd=z

export PATH="$PATH:$HOME/.cargo/bin"

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

if [[ -z "$TMUX" ]]; then
    if tmux has-session 2>/dev/null; then
        exec tmux attach-session
    else
        ~/dotfiles/scripts/tmux-session.sh
    fi
fi

setopt PROMPT_SUBST
PROMPT='$(prmt --shell zsh --code $? "{path:cyan:rs} {git:purple} {ok:green:❯}{fail:red:❯} ")'

eval "$(direnv hook zsh)"

export STEEL_HOME="$HOME/.steel"
