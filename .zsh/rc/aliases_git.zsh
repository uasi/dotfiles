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
    bl
    c
    ci
    cia
    co
    com
    copr
    di
    dis
    fetch
    ff
    fix
    l
    lg
    ll
    m
    pull
    pullff
    pullr
    push
    pushfl
    re
    rea
    rec
    recommit
    reflog
    rei
    reib
    reset
    reseth
    reseth1
    reseth2
    reseth3
    rev
    sdi
    sdis
    sl
    st
    stash
    tag
    uncommit
    unmerge
    unstage
    unstagef
    wip
)
for cmd in $git_aliases; do
    alias $cmd="noglob git $cmd"
done

alias gg='noglob git grep'
