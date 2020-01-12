git() {
    if [[ "$PWD" = "$HOME" ]]; then
        "${commands[git]}" --git-dir=~/.dotfiles.git --work-tree=~ "$@"
    else
        "${commands[git]}" "$@"
    fi
}

tig() {
    if [[ "$PWD" = "$HOME" ]]; then
        GIT_DIR=~/.dotfiles.git "${commands[tig]}" "$@"
    else
        "${commands[tig]}" "$@"
    fi
}

typeset -a git_aliases
git_aliases=(
    add
    amend
    b
    c
    ci
    cia
    recommit
    co
    copr
    di
    dis
    l
    ll
    lg
    fetch
    ff
    fix
    m
    pull
    pullff
    pullr
    push
    pushfl
    re
    reflog
    rea
    rec
    rei
    reib
    reset
    rev
    reseth
    reseth1
    reseth2
    reseth3
    stash
    uncommit
    unmerge
    unstage
    st
    tag
    wip
)
for cmd in $git_aliases; do
    alias $cmd="git $cmd"
done

alias gg='git grep'
