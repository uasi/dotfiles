# Utilities
alias pbindent4='pbpaste | sed "s/^/    /" | pbcopy'
alias is-login-sh='ps $$ | awk "NR == 2 && \$5 ~ /^-/ { print \"yes\"; }"'
alias is-session-leader='ps $$ | awk "NR == 2 && \$3 ~ /s/ { print \"yes\" }"'
alias @='noglob'
alias unsymlink='sed "" -i'
alias ssh-qiita='ssh $(grep -o "app-qiita-public-.*" "$HOME/.ssh/config_ec2" | head -n1)'

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
alias j=jobs

# chdir shorthands
alias -g ...=../..
alias -g ....=../../..
alias -g .....=../../../..

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

# Alternatives
has colordiff && alias diff=colordiff # brew install colordiff; https://www.colordiff.org
has exa && alias ls=exa # brew install exa; https://the.exa.website

# Noglob
alias youtube-dl='noglob \youtube-dl'
