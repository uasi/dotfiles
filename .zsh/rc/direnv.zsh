if has direnv; then
    _direnv_hook() {
        eval "$(direnv export zsh)";
    }

    typeset -a precmd_functions

    if [[ -z $precmd_functions[(r)_direnv_hook] ]]; then
        precmd_functions+=_direnv_hook;
    fi
fi
