# Taken from http://qiita.com/mollifier/items/14bbea7503910300b3ba
zman() {
    PAGER="less -g -s '+/^       "$1"'" man zshall
}

# Taken from http://qiita.com/yuyuchu3333/items/67630d597c7700a51b95
zmanf() {
    local w='^'
    w=${(r:8:)w}
    w="$w${(r:7:)1}|$w$1(\[.*\].*)|$w$1:.*:|$w$1/.*/.*"
    PAGER="less -g -s '+/"$w"'" man zshall
    echo "Search word: $w"
}

help() {
    local pager=$PAGER
    local helpdir=$HOME/.help
    [[ -n $pager ]] || pager=less
    if [[ -z $1 ]]; then
        echo "Available helps:"
        for name in $helpdir/*.md; do
            echo `basename $name .md`
        done
        return
    fi
    if [[ ! -e "$helpdir/$1.md" ]]; then
        echo "No help for $1"
        return 1
    fi
    $pager "$helpdir/$1.md"
}

unpath() {
    local item
    local paths
    local tmppath

    paths=`where $1`

    if [[ "$paths" != "$1 not found" ]]; then
        for item in ${=paths}; do
            tmppath=$(eval "echo \${path:#$(dirname $item)}")
            PATH=${tmppath// /:}
            # We may not modify path directly?
            # path=${=tmppath}
        done
    fi
}

ssh-copy-id() {
    if [[ -z "$1" ]]; then
        echo 'Usage: ssh-copy-id <remote-host>'
        return
    fi
    cat $HOME/.ssh/id_rsa.pub | ssh $* "cat >> ~/.ssh/authorized_keys"
    if [[ $? = 0 ]]; then
        echo "Your public key is appended to .ssh/authorized_keys"
    fi
}

tmux-attach-or-start() {
    if tmux has-session; then
        tmux attach
    else
        tmux
    fi
}

# Remove com.apple.quarantine attribute from files
untaint() {
    xattr -d com.apple.quarantine "$@" 2> /dev/null
}



# Launch Xcode (with a project)
xcode() {
    local files
    files=(*.xcworkspace(N) *.xcodeproj)
    if [[ -n "$files[1]" ]]; then
        open "$files[1]"
    else
        open -a /Developper/Applications/Xcode.app
    fi
}

pbsed() {
    pbpaste | sed "$@" | pbcopy
}

# _fzf_trampoline [options]
# _fzf_trampoline query [options]
_fzf_trampoline() {
    if [[ "$1" = -* ]]; then
        fzf "$@"
    elif [[ -n "$1" ]]; then
        local query
        query=$(sed "s/^:/'/" <<< "$1")
        shift
        fzf -q "$query" "$@"
    else
        fzf
    fi
}

gitf() {
    local dir="$(ghq list -p | _fzf_trampoline "$@" -1)"
    if [[ -n "$dir" ]]; then
        echo cd "${(q)dir}"
        cd "$dir"
    fi
}

gitp() {
    local dir="$(ghq list -p | _fzf_trampoline "$@" -1)"
    if [[ -n "$dir" ]]; then
        echo "$dir"
    fi
}

vimf() {
    local files
    files=("${(@f)$(_fzf_trampoline "$@" -1)}")
    [[ $? = 0 ]] || return 1
    if [[ $#files < 4 ]]; then
        num_windows=$#files
    else
        num_windows=3
    fi
    vim -O$num_windows "${(@)files}"
}

netcopy() {
    nc termbin.com 9999
}

netpaste() {
    (( $# )) || return 1
    curl "https://termbin.com/$1"
}
