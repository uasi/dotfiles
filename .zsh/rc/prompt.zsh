autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null

rprompt-git-current-branch() {
    local name misc_info st color gitdir action
    if [[ "$PWD/" = */.git/* ]]; then
        return
    fi
    gitdir=`git rev-parse --git-dir 2> /dev/null`
    if [[ -z "$gitdir" ]]; then
        return
    fi
    if ! name=${$(git describe --always --all --exact-match 2> /dev/null)#*/}; then
        name="(no HEAD)"
    fi
    action=`VCS_INFO_git_getaction "$gitdir"`
    if [[ -n "$action" ]]; then
        action="($action)"
    fi

    if [[ -e "$gitdir/rprompt-nostatus" ]]; then
        echo "%F{247}$name$action%f "
        return
    fi

    st=`git status 2> /dev/null`
    if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
        color=%F{green}
    elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
        color=%F{yellow}
    elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
        color=%B%F{red}
    else
        color=%F{red}
    fi

    if [[ -d "$gitdir/../,patchbox" ]]; then
        local patches
        patches=`ls "$gitdir/../,patchbox" | wc -l | cut -c8-`
        if [[ $patches > 0 ]]; then
            misc_info="patch($patches) "
        fi
    fi

    echo "%F{240}$misc_info%f$color$name$action%f%b%F{black} "
}

rprompt-todo() {
    if [[ -f ,TODO ]]; then
        items=`grep --count "^- " ,TODO`
        if [[ $items > 0 ]]; then
            echo "%F{240}todo($items) %f"
        fi
    fi
}

'#prompt/is-herdr-running'() {
    [[ "$(herdr status server)" = $'status: running\n'* ]]
}

RPROMPT+='$([[ `jobs` =~ "suspended  n?vimf?" ]] && print "[vim]")'
RPROMPT+='$([[ `jobs` =~ "suspended  tig" ]] && print "[tig]")'

if has herdr; then
    RPROMPT+='$("#prompt/is-herdr-running" && print "[herdr]")'
fi

RPROMPT+='[`rprompt-todo``rprompt-git-current-branch`%F{8}%40<..<%f%~%<<]'

typeset -A __rc_prompt

'#prompt/generate'() {
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

'#prompt/line-init'() {
    [[ $CONTEXT = start ]] || return 0

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

PROMPT='$("#prompt/generate")'

zle -N zle-line-init '#prompt/line-init'
