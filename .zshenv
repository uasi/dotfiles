#-- Prelude {{{ --------------------------------------------------------------

if [[ "${ZSH_PROFILE:-undef}" != undef ]]; then
    zmodload zsh/zprof && zprof
fi

export ZSHHOME=$HOME/.zsh

has() {
    command -v "$1" > /dev/null
}

#-- Prelude }}}---------------------------------------------------------------
#-- User settings {{{ --------------------------------------------------------

export NAME=uasi
export REALNAME="Tomoki Aonuma"
export EMAIL="uasi@uasi.jp"
export EDITOR=vim

source ~/Dropbox/Data/Dotfiles/sh/secret_env.sh

#-- User settings }}} --------------------------------------------------------
#-- Zsh settings {{{ ---------------------------------------------------------

# Command history settings
export HISTFILE=$HOME/.zsh-history
export HISTSIZE=100000
export SAVEHIST=100000

#-- Zsh settings }}} ---------------------------------------------------------
#-- Application settings {{{ -------------------------------------------------

# Docker
export DOCKER_HIDE_LEGACY_COMMANDS=true # Show only new commands in docker --help.

# Erlang/Elixir
export ERL_AFLAGS="-kernel shell_history enabled"

# Elixir
export IEX_WITH_WERL=1 # Enable autocompletion in iex shell.

# fzf
export FZF_DEFAULT_OPTS="--multi --extended"

#-- Application settings }}} -------------------------------------------------
#-- PATHs {{{ ----------------------------------------------------------------

path=(
    # Git
    $HOME/.gitbin(N-/)

    # Rust
    $HOME/.cargo/bin(N-/)

    # Visual Studio Code
    '/Applications/Visual Studio Code.app/Contents/Resources/app/bin'(N-/)

    # NotionJS
    $HOME/.notion/bin(N-/)

    # nodebrew
    $HOME/.nodebrew/current/bin(N-/)

    # rbenv
    $HOME/.rbenv/shims(N-/)

    # Local
    $HOME/bin(N-/)
    /usr/local/(s|)bin(N-/)
    $HOME/Dropbox/Data/Executables(N-/)

    ${path}
)

cdpath=$HOME

fpath=(
    $ZSHHOME/functions(N-/)
    /usr/local/share/zsh-completions(N-/)
    ${fpath}
)

# Save PATH in case we need to restore PATH clobbered by system-wide
# configuration scripts.
_path=$PATH
typeset -U _path

#-- PATHs }}} ----------------------------------------------------------------
