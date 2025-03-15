explainshell() {
    open "https://explainshell.com/explain?cmd=$(ruby -rcgi -e 'puts CGI.escape(ARGV.join(" "))' -- "$@")"
}

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

cdm() {
    [[ -n "$1" ]] || return 1
    mkdir -p -- "$1"
    cd -- "$1"
}

cdl() {
    local last_cmd=$(fc -l -LIn -1) # [l]ist hist item, [L]ocal (not from other shells), [I]nternal (not from $HISTFILE), no hist [n]umber, [1]st entry from last
    local last_arg=${(Q)${(z)last_cmd}[-1]}
    echo cd "$last_arg"
    cd -- "$last_arg"
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

    cat >> .envrc <<'EOS'
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
compdef _tm tm

_tm_presets() {
    # Hint: _values <group-name> <candidate>...
    _values \
        preset \
        ~/.config/tmux/presets/^README.md(.:t)
}

launch() {
    local usage="\
usage: launch (up|down|reload|run|edit) [-d <domain-target>] <plist-name>
usage: launch list"

    local -A opts=()
    zparseopts -D -E -F -A opts -- h -help d:

    local -A actions=(
        up     bootstrap
        down   bootout
        reload reload
        run    kickstart
        list   list
        ls     list
        edit   edit
    )

    local domain=${opts[-d]:-gui/$(id -u)}
    local action=${actions[$1]}
    local plist_name=$2

    case $action in
        ""|-h|--help)
            echo "$usage" >&2
            return 1
            ;;
        bootstrap|bootout|reload|kickstart|edit)
            if [[ -z "$plist_name" ]]; then
                echo "$usage" >&2
                return 1
            fi
            ;;
    esac

    case $action in
        bootstrap|bootout)
            echo \# launchctl "$action" "$domain" \~/Library/LaunchAgents/"$plist_name"
            launchctl "$action" "$domain" ~/Library/LaunchAgents/"$plist_name"
            ;;
        reload)
            launch down -d "$domain" "$plist_name" && launch up -d "$domain" "$plist_name"
            ;;
        kickstart)
            local label=$(/usr/libexec/PlistBuddy -c "print :Label" ~/Library/LaunchAgents/"$plist_name")
            echo \# launchctl kickstart "$domain/$label"
            launchctl kickstart "$domain/$label"
            ;;
        list)
            ( cd ~/Library/LaunchAgents && ls )
            ;;
        edit)
            "$EDITOR" ~/Library/launchAgents/"$plist_name"
            ;;
    esac
}

_launch() {
    _arguments '-d[domain]: :->domains' '1: :->commands' '2: :_launchagents_list'
    case $state in
        domains)
            _values \
                domain \
                system "user/$(id -u)" "gui/$(id -u)"
            ;;
        commands)
            _values \
                command \
                up down reload run list edit
            ;;
    esac
}
compdef _launch launch

_launchagents_list() {
    _values \
        LaunchAgents \
        ~/Library/LaunchAgents/*.plist(:t)
}

_restic-driver() {
    _arguments '1: :->commands' '*: :->configs'
    case $state in
        commands)
            _values \
                command \
                backup forget
            ;;
        configs)
            _values \
                config \
                ~/.config/restic-driver/*.toml(:r:t)
            ;;
    esac
}
compdef _restic-driver restic-driver

rn() {
    if [[ $# = 0 ]]; then
        if [[ ! -e package.json ]]; then
            echo "error: package.json not found" >&2
            exit 1
        fi
        node -e 'Object.entries(JSON.parse(require("fs").readFileSync("package.json")).scripts || {}).forEach(([k, v]) => console.log(`${k}\t\x1b[32m${v}\x1b[0m`))' | column -t -s $'\t'
    else
        if [[ -e yarn.lock ]]; then
            yarn run "$@"
        elif [[ -e pnpm-lock.yaml ]]; then
            pnpm run "$@"
        else
            npm run "$@"
        fi
    fi
}

_rn() {
    # Adapted from "$(npm completion)"
    local si=$IFS
    compadd -- $(COMP_CWORD=2 \
                 COMP_LINE="npm run " \
                 COMP_POINT=0 \
                 npm completion -- npm run "" \
                 2>/dev/null)
    IFS=$si
}
compdef _rn rn

# Complete case-insensitively and make matching occur on both sides of the current word.
zstyle ':completion:*:complete:tm:*' matcher '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*'
