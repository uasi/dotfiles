typeset -a precmd_functions

if has direnv; then
    _precmd_direnv_hook() {
        eval "$(direnv export zsh)"
    }

    if [[ -z $precmd_functions[(r)_direnv_hook] ]]; then
        precmd_functions+=_precmd_direnv_hook
    fi
fi
