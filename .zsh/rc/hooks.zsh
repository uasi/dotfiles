typeset -a chpwd_functions
typeset -a precmd_functions

_chpwd_dotfiles_git_hook() {
    if [[ "$PWD" = "$HOME" ]]; then
        if [[ -z "$GIT_DIR" && -e "$HOME/.dotfiles.git" ]]; then
            echo "chpwd: Set GIT_DIR and GIT_WORK_TREE"
            export GIT_DIR=$HOME/.dotfiles.git
            export GIT_WORK_TREE=$HOME
        fi
    else
        echo "chpwd: Unset GIT_DIR and GIT_WORK_TREE"
        unset GIT_DIR
        unset GIT_WORK_TREE
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
