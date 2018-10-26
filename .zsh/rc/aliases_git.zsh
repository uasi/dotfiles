alias git='noglob git'

typeset -a git_aliases
git_aliases=(
    add
    amend
    b
    blf
    c
    ci
    cia
    recommit
    co
    di
    dis
    l
    ll
    lg
    fetch
    ff
    fix
    m
    ms
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
for cmd ($git_aliases) {
    alias $cmd="git $cmd"
}
