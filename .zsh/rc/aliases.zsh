# Utilities
alias pbindent4='pbpaste | sed "s/^/    /" | pbcopy'
alias is-login-sh='ps $$ | awk "NR == 2 && \$5 ~ /^-/ { print \"yes\"; }"'
alias is-session-leader='ps $$ | awk "NR == 2 && \$3 ~ /s/ { print \"yes\" }"'
alias @='noglob'
alias unsymlink='sed "" -i'

# Platform-specific utilities
case "$OSTYPE" in
    darwin*)
    alias ls='ls -G -w'
    alias setutf8='xattr -w com.apple.TextEncoding "utf-8;134217984"'
    alias wherefroms='xattr -p com.apple.metadata:kMDItemWhereFroms'
    alias usermod='echo "usermod is not available on macOS; use `dscl . [add|rm|read] /Groups/$GROUP GroupMembership $USER` instead'
    ;;
    linux*)
    alias ls='ls --color=auto'
    ;;
esac

# Shorthands for builtin commands
alias h=history

# chdir shorthands
alias -g ...=../..
alias -g ....=../../..
alias -g .....=../../../..
alias -g ......=../../../../..
alias -g .......=../../../../../..

# Directories
hash -d gh="$HOME/repos/github.com"
hash -d icloud="$HOME/Library/Mobile Documents/com~apple~CloudDocs"

# zmv
autoload -Uz zmv
alias zcp='noglob zmv -W -C'
alias zln='noglob zmv -W -L'
alias zmv='noglob zmv -W'

# Foolproof
alias halt='echo Use \\halt if you are sure'
alias shutdown='echo Use \\shutdown if you are sure'
alias suspend='echo Use \\suspend if you are sure'

# Bundler
alias be='bundle exec'
alias bi='bundle install'
alias bu='bundle update'

# Yarn
alias ya='yarn add'
alias yi='yarn install'
alias yr='yarn run'
alias yrm='yarn remove'
alias yul='yarn upgrade --latest'
alias yui='yarn upgrade-interactive'
alias yuil='yarn upgrade-interactive --latest'

# Shorthands
alias .j='just --justfile=~/.config/just/Justfile'
alias .J='just --justfile=~/.config/just/Justfile --choose'
alias j=just
alias J='just --choose'
alias phog='RUST_BACKTRACE=full phog'
alias ydl=youtube-dl
alias ydl-live='youtube-dl --hls-use-mpegts --fragment-retries=30 --keep-fragments'

# Alternatives
has colordiff && alias diff=colordiff # brew install colordiff; https://www.colordiff.org
has eza && alias ls='eza --time-style long-iso' # brew install eza; https://eza.rocks

# Noglob
alias youtube-dl='noglob \youtube-dl'
