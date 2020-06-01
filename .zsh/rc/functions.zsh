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

mkbin() {
    if [[ -z "$1" ]]; then
        echo "Usage: mkbin <name>" >&2
        return 1
    fi

    local name=$1

    if [[ ! -e "$name" ]]; then
        cat > "$name" <<'EOS'
#!/bin/bash


EOS
    fi

    chmod +x "$name"
    vim '+$' "$name"
}

mk,bin() {
    if [[ -e ,bin ]]; then
        echo "Error: ,bin already exists" >&2
        return 1
    fi

    mkdir ,bin

    if [[ -e .envrc ]]; then
        echo "Warn: .envrc already exists" >&2
        return 0
    fi

    cat > .envrc <<'EOS'
export PATH=$PWD/,bin:$PATH
EOS

    if (( $+commands[direnv] )); then
        direnv allow
    else
        echo "Warn: direnv not found; did not run \`direnv allow\`"
        return 0
    fi
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

alias f=gitf

f:() {
    local arg1=":$1"
    [[ $# > 0 ]] && shift
    gitf "$arg1" "$@"
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

# netcopy/netpaste support poor man's encryption.
# netcopy_netpaste_key should be an RSA private key, in the old (PEM) format,
# not protected by passphrase.

netcopy() {
    if [[ ! -e ~/.ssh/netcopy_netpaste_key ]]; then
        echo "error: ~/.ssh/netcopy_netpaste_key does not exist"
        return 1
    fi

    local pass=$(openssl rand 128 -base64)
    local encrypted_pass=$(echo "$pass" | openssl rsautl -encrypt -inkey ~/.ssh/netcopy_netpaste_key | base64)

    {
        echo "$encrypted_pass"
        openssl enc -e -aes256 -pass "pass:$pass" -base64
    } | nc termbin.com 9999
}

netpaste() {
    if [[ $# = 0 ]]; then
        echo "usage: netpaste <id>"
        return 1
    fi

    if [[ ! -e ~/.ssh/netcopy_netpaste_key ]]; then
        echo "error: ~/.ssh/netcopy_netpaste_key does not exist" >&2
        return 1
    fi

    curl -s "https://termbin.com/$1" | {
        local pass=$(read -r -e | base64 -d | openssl rsautl -decrypt -inkey ~/.ssh/netcopy_netpaste_key)

        base64 -d | openssl enc -d -aes256 -pass "pass:$pass"
    }
}

mygem() {
    if [[ ! -e ~/.gem/mygemrc ]]; then
        echo "warning: ~/.gem/mygemrc does not exist." >&2
    fi
    if [[ "$(stat -f "%p" ~/.gem/mygemrc)" != *600 ]]; then
        echo "warning: File mode of ~/.gem/mygemrc is other than 600." >&2
    fi

    GEMRC=$HOME/.gem/mygemrc gem "$@"
}

tm() {
    if [[ -z "$1" ]]; then
        echo "usage: tm <tmux-preset>" >&2
        return 1
    fi

    local file
    if [[ "$1" = */* ]]; then
        file=$1
    else
        file=~/.config/tmux/presets/$1
    fi

    if [[ -x "$file" ]]; then
        "$file"
    else
        tmux source-file "$file"
    fi
}

_tm() {
    # Hint: _arguments '<arg-pos-to-complete>:<desc>:<completer>'
    _arguments '1: :_tm_presets'
}

_tm_presets() {
    # Hint: _values <group-name> <candidate>...
    _values \
        preset \
        ~/.config/tmux/presets/^README.md(.:t)
}

compdef _tm tm

# Complete case-insensitively and make matching occur on both sides of the current word.
zstyle ':completion:*:complete:tm:*' matcher '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*'
