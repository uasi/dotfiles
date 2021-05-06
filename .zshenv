#-- Prelude {{{ --------------------------------------------------------------

if [[ "${ZSH_PROFILE:+x}" = x ]]; then
    zmodload zsh/zprof
fi

export ZSHHOME=$HOME/.zsh

has() {
    (( $+commands[$1] ))
}

#-- Prelude }}}---------------------------------------------------------------
#-- User settings {{{ --------------------------------------------------------

export NAME=uasi
export REALNAME="Tomoki Aonuma"
export EMAIL="uasi@uasi.jp"
export EDITOR=vim

#-- User settings }}} --------------------------------------------------------
#-- Zsh settings {{{ ---------------------------------------------------------

# Command history settings
export HISTFILE=$HOME/.zsh-history
export HISTSIZE=100000
export SAVEHIST=100000

#-- Zsh settings }}} ---------------------------------------------------------
#-- Application settings {{{ -------------------------------------------------

# Deno
export DENO_DIR=$HOME/.local/share/deno
export DENO_INSTALL_ROOT=$DENO_DIR

# Docker
export DOCKER_HIDE_LEGACY_COMMANDS=true # Show only new commands in docker --help.

# Erlang/Elixir
export ERL_AFLAGS="-kernel shell_history enabled"

# Elixir
export IEX_WITH_WERL=1 # Enable autocompletion in iex shell.

# fzf
export FZF_DEFAULT_COMMAND="rg -l --hidden ''"
export FZF_DEFAULT_OPTS="--multi --extended"

# Go
export GOPATH=$HOME/.local/share/go

# Python 3.8 bug?
#
# If LC_CTYPE is unset, it dies on startup with the message below:
#
# > Fatal Python error: config_get_locale_encoding: failed to get the locale encoding: nl_langinfo(CODESET) failed
# > Python runtime state: preinitialized
#
# `nl_langinfo(CODESET)` seems to return LC_CTYPE: https://linuxjm.osdn.jp/html/LDP_man-pages/man3/nl_langinfo.3.html
#
# Related discussion: https://bugs.python.org/issue39397
export LC_CTYPE=ja_JP.UTF-8

# Ripgrep
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/config

# Ruby
export RUBYLIB=$HOME/.local/lib/ruby

### My apps

# phog
export PHOG_CONFIG_DIR=$HOME/Dropbox/Data/phog
export PHOG_DATA_DIR=$HOME/Dropbox/Data/phog

# photo_grabber
export PHOTO_GRABBER_DATA_DIR=$HOME/Dropbox/Data/photo_grabber

#-- Application settings }}} -------------------------------------------------
#-- PATHs {{{ ----------------------------------------------------------------

path=(
    # Local (high priority)
    $HOME/bin(N-/)

    # Deno
    $DENO_INSTALL_ROOT/bin(N-/)

    # Go
    $HOME/.local/share/go/bin(N-/)

    # Rust
    $HOME/.cargo/bin(N-/)

    # Sublime Merge
    '/Applications/Sublime Merge.app/Contents/SharedSupport/bin'(N-/)

    # Sublime Text
    '/Applications/Sublime Text.app/Contents/SharedSupport/bin'(N-/)

    # Visual Studio Code
    '/Applications/Visual Studio Code.app/Contents/Resources/app/bin'(N-/)

    # Volta
    $HOME/.volta/bin(N-/)

    # nodebrew
    $HOME/.nodebrew/current/bin(N-/)

    # rbenv
    $HOME/.rbenv/shims(N-/)

    # Local
    $HOME/.local/bin(N-/)
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
