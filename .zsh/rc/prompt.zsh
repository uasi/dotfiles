autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null

git-current-branch() {
    git branch 2> /dev/null | grep '^\*' | cut -b 3-
}

rprompt-git-current-branch() {
    local name misc_info st color gitdir action
    if [[ "$PWD/" = */.git/* ]]; then
        return
    fi
    gitdir=`git rev-parse --git-dir 2> /dev/null`
    if [[ -z "$gitdir" ]]; then
        return
    fi
    name=`git-current-branch`
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

RPROMPT+='$([[ `jobs` =~ "suspended  n?vimf?" ]] && print "[vim]")'
RPROMPT+='$([[ `jobs` =~ "suspended  tig" ]] && print "[tig]")'
if [[ -n "$SSH_CONNECTION" ]]; then
    PROMPT="%F{166}->%f $PROMPT%f"
else
    PROMPT="%F{64}->%f %# "
fi

RPROMPT+='[`rprompt-todo``rprompt-git-current-branch`%F{red}%40<..<%f%~%<<]'
