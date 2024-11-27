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
export LANG=en_US.utf-8

# Explicitly set the XDG_* variables to their default values in the hope of
# overriding preference of certain softwares (e.g. pnpm) that would otherwise
# use macOS paths such as ~/Library.
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

#-- User settings }}} --------------------------------------------------------
#-- Zsh settings {{{ ---------------------------------------------------------

# Command history settings
export HISTFILE=$HOME/.zsh-history
export HISTSIZE=100000
export SAVEHIST=100000

#-- Zsh settings }}} ---------------------------------------------------------
#-- Application settings {{{ -------------------------------------------------

# .NET
export DOTNET_CLI_UI_LANGUAGE=en-US

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

# pnpm
export PNPM_HOME=$HOME/.local/share/pnpm/bin

# Ripgrep
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/config

# Ruby
export RUBYLIB=$HOME/.local/lib/ruby

# Rye
export RYE_HOME=$HOME/.local/share/rye

# uv
export UV_TOOL_BIN_DIR=$HOME/.local/share/uv/bin

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
    $HOME/bin

    # Deno
    $DENO_INSTALL_ROOT/bin

    # Elixir
    $HOME/.mix/escripts

    # Go
    $HOME/.local/share/go/bin

    # JetBrains Toolbox
    $HOME/'Library/Application Support/JetBrains/Toolbox/scripts'

    # pnpm
    $HOME/.local/share/pnpm/bin

    # rbenv
    $HOME/.rbenv/shims

    # Rancher Desktop
    $HOME/.rd/bin

    # Rust
    $HOME/.cargo/bin

    # Sublime Merge
    '/Applications/Sublime Merge.app/Contents/SharedSupport/bin'

    # Sublime Text
    '/Applications/Sublime Text.app/Contents/SharedSupport/bin'

    # uv
    $HOME/.local/share/uv/bin

    # Visual Studio Code
    '/Applications/Visual Studio Code.app/Contents/Resources/app/bin'


    # ---

    # Local
    $HOME/.local/bin
    /usr/local/(s|)bin
    $HOME/Dropbox/Data/Executables

    # Homebrew
    /opt/homebrew/bin
    /opt/homebrew/(s|)bin
    /opt/homebrew/opt/postgresql@*/bin

    $path
)
path=(${(u)^path:A}(N-/))

cdpath=$HOME

fpath=(
    $ZSHHOME/functions
    /usr/local/share/zsh-completions
    $fpath
    $ZSHHOME/functions_fallback
)
fpath=(${(u)^fpath:A}(N-/))

# Save PATH in case we need to restore PATH clobbered by system-wide
# configuration scripts.
_path=$PATH
typeset -U _path

#-- PATHs }}} ----------------------------------------------------------------
