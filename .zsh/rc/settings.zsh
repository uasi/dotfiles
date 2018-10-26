setopt auto_cd
setopt auto_pushd
setopt auto_remove_slash
setopt cdable_vars
setopt extended_glob
setopt extended_history
setopt hist_expand
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_no_store
setopt magic_equal_subst
setopt no_flow_control
setopt prompt_subst
setopt pushd_ignore_dups
setopt share_history
setopt transient_rprompt

# Command completion
zstyle ':completion:*:sudo:*' command-path $path

# Color completion candidates
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# <tab><tab> to move around completion candidates with Ctrl-F/B/N/P
zstyle ':completion:*:default' menu select=1

# Make `kill <process_name>` completion includes other users' processes
zstyle ':completion:*:processes' command "ps -u $USER"

# Always use autoload -Uz !
#
# -z  unset ksh-compat flag (i.e. turn *z*sh-native mode on)
# -U  suppress alias expansion when the function is loaded
#     see `typeset -f` in `zshbuiltins` for the detail

# Smart last word insertion
# Type Esc-_ or Esc-. to insert the last word of the previous command
# See http://qiita.com/mollifier/items/1a9126b2200bcbaf515f
autoload -Uz smart-insert-last-word
zle -N insert-last-word smart-insert-last-word

autoload -Uz compinit; compinit

# User-friendly coloring
# e.g. echo ${fg[red]}Red!${reset_color}
autoload -Uz colors; colors

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

autoload -Uz zargs

# Toggle between zsh and vim with ^Z
run-fg-editor() {
    zle push-input
    fg vim 2> /dev/null || fg tig 2> /dev/null || true
    # Put empty line to avoid prompt glitch
    BUFFER=""
    zle accept-line
}
zle -N run-fg-editor
bindkey '^z' run-fg-editor

bindkey -e

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
