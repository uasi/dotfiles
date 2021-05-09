git() {
    if [[ "$PWD" = "$HOME" ]]; then
        noglob "${commands[git]}" --git-dir=~/.dotfiles.git --work-tree=~ "$@"
    else
        noglob "${commands[git]}" "$@"
    fi
}

tig() {
    if [[ "$PWD" = "$HOME" ]]; then
        GIT_DIR=~/.dotfiles.git noglob "${commands[tig]}" "$@"
    else
        noglob "${commands[tig]}" "$@"
    fi
}

typeset -a git_aliases
git_aliases=(
    add
    addf
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
    sdi
    sdis
    sl
    stash
    uncommit
    unmerge
    unstage
    unstagef
    st
    tag
    wip
)
for cmd in $git_aliases; do
    alias $cmd="noglob git $cmd"
done

alias gg='noglob git grep'
