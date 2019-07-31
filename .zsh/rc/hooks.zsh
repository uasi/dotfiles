typeset -a chpwd_functions
typeset -a precmd_functions

_chpwd_dotfiles_git_hook() {
    if [[ "$PWD" = "$HOME" ]]; then
        if [[ -z "$GIT_DIR" && -e "$HOME/.dotfiles.git" ]]; then
            echo "chpwd: Set GIT_DIR"
            export GIT_DIR=$HOME/.dotfiles.git
        fi
    else
        echo "chpwd: Unset GIT_DIR"
        unset GIT_DIR
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
