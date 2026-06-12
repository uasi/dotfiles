typeset -A __rc_prompt

autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2>/dev/null

'#prompt/probe/herdr'() {
    if [[ "$(herdr status server)" = $'status: running\n'* ]]; then
        local agent_count=$(herdr agent list | wc -l)
        print -r -n -- "[herdr $(( agent_count ))]"
    fi
}

'#prompt/probe/suspended-jobs'() {
    local line name

    while IFS=$'\n' read -r line; do
        name=${line#* suspended  }
        [[ -n "$name" ]] && print -r -n -- "[$name]"
    done <<< "${__rc_prompt[jobs]}"
}

'#prompt/probe/jj'() {
    if [[ -z "$(jj workspace root 2>/dev/null)" ]]; then
        return
    fi

    local st=$(jj log -r '@' -T 'bookmarks.join(" ") ++ ":empty=" ++ empty ++ ":anon=" ++ (description.trim().len() == 0)' --no-graph)

    local edited titled

    if [[ "$st" = *:empty=true:* ]]; then
        edited='%F{green}'
    else
        edited='%F{red}'
    fi

    if [[ "$st" = *:anon=false ]]; then
        titled='%U'
    fi

    local bm=${st/:*/}

    if [[ -z "$bm" ]]; then
        bm=$(jj log -r 'heads(::@ & bookmarks())' -n 1 -T 'bookmarks.join(" ")' --no-graph)

        if [[ -n "$bm" ]]; then
            bm="$bm%f%u.."
        else
            bm='<no bookmark>'
        fi
    fi


    print -r -n -- "jj(${edited}${titled}${bm}%f%u) "
}

'#prompt/probe/git'() {
    local name st color gitdir action

    if [[ "$PWD/" = */.git/* ]]; then
        return
    fi

    gitdir=$(git rev-parse --git-dir 2>/dev/null)

    if [[ -z "$gitdir" ]]; then
        return
    fi

    if (( $+commands[jj] )) && [[ -n "$(jj workspace root 2>/dev/null)" ]]; then
        return
    fi

    if ! name=${$(git describe --always --all --exact-match 2>/dev/null)#*/}; then
        name="(no HEAD)"
    fi

    action=$(VCS_INFO_git_getaction "$gitdir")

    if [[ -n "$action" ]]; then
        action="($action)"
    fi

    if [[ -e "$gitdir/rprompt-nostatus" ]]; then
        print -r -n -- "%F{247}$name$action%f "
        return
    fi

    st=$(git status --porcelain 2>/dev/null)

    if [[ -z "$st" ]]; then
        color=%F{green}
    elif [[ "$st" =~ "^[^?][^?]" ]]; then
        color=%F{red}
    else
        color=%F{yellow}
    fi

    print -r -n -- "$color$name$action%f%F{black} "
}

'#prompt/left/generate'() {
    local compact_prompt='-> %# '

    if (( __rc_prompt[compact] )); then
        print -r -- "$compact_prompt"
        return
    fi

    local box_tl=$'\u256D'
    local box_bl=$'\u2570'
    local box_hr=$'\u2500'
    local box_vt=$'\u2502'

    local ident='%n@%M'
    local hr_suffix_raw=" ${(%)ident} "
    local hr_suffix="${hr_suffix_raw//\%/%%}"
    local hr_cols=$(( $(tput cols) - ${#box_hr} - ${#hr_suffix_raw} ))

    if (( hr_cols < 0 )); then
        print -r -- "$compact_prompt"
        return
    fi

    local hr="${(pl:$hr_cols::$box_hr:)}"

    print -r -- "$box_tl$hr$hr_suffix"
    print -r -- "$box_vt"
    print -r -- "$box_bl$box_hr %# "
}

'#prompt/right/statuses'() {
    local s

    (( $+commands[herdr] )) && s+='$("#prompt/probe/herdr")'
    s+='$("#prompt/probe/suspended-jobs")'

    print -r -n -- "$s"
}

'#prompt/right/vcs'() {
    local s

    (( $+commands[jj] )) && s+='$("#prompt/probe/jj")'
    (( $+commands[git] )) && s+='$("#prompt/probe/git")'

    print -r -n -- "$s"
}

'#prompt/right/pwd'() {
    print -r -n -- '%F{8}%40<..<%f%~%<<'
}

'#prompt/line-init'() {
    [[ $CONTEXT = start ]] || return 0

    # Capture jobs before entering recursive edit context
    __rc_prompt[jobs]=$(jobs)

    (( $+zle_bracketed_paste )) && print -r -n -- "${zle_bracketed_paste[1]}"
    zle .recursive-edit
    local -i ret=$?
    (( $+zle_bracketed_paste )) && print -r -n -- "${zle_bracketed_paste[2]}"

    # On Ctrl-D
    if [[ $ret = 0 && $KEYS = $'\C-D' ]]; then
        __rc_prompt[compact]=1
        zle .reset-prompt
        exit
    fi

    __rc_prompt[compact]=1
    zle .reset-prompt
    __rc_prompt[compact]=0

    if (( ret )); then
        # On Ctrl-C
        zle .send-break
    else
        # On Enter
        zle .accept-line
    fi

    return ret
}

zle -N zle-line-init '#prompt/line-init'

PROMPT='$("#prompt/left/generate")'
RPROMPT="$("#prompt/right/statuses")[$("#prompt/right/vcs")$("#prompt/right/pwd")]"
