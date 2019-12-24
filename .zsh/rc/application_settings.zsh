[[ -s "$HOME/.volta/load.sh" ]] && source "$HOME/.volta/load.sh"

[[ -s "$HOME/.cpad2/profile" ]] && source "$HOME/.cpad2/profile"

if has brew; then
    source "$(brew --prefix)"/opt/fzf/shell/{completion,key-bindings}.zsh 2> /dev/null
fi
