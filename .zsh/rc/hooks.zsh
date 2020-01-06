typeset -a chpwd_functions
typeset -a precmd_functions

_chpwd_dotfiles_git_hook() {
    if [[ "$PWD" = "$HOME" ]]; then
        alias git="noglob git --git-dir=~/.dotfiles.git --work-tree=~"
    elif [[ "$OLDPWD" = "$HOME" ]]; then
        alias git="noglob git"
    fi
}

_chpwd_dotfiles_git_hook

chpwd_functions+=_chpwd_dotfiles_git_hook

if has direnv; then
    _precmd_direnv_hook() {
        eval "$(direnv export zsh)"
    }

    if [[ -z $precmd_functions[(r)_direnv_hook] ]]; then
        precmd_functions+=_precmd_direnv_hook
    fi
fi
