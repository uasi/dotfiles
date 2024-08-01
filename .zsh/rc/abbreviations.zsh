typeset -A abbreviations
abbreviations=(
    " A"  " | atline"
    " G"  " | ${${commands[rg]:t}:-grep}"
    " F"  " | fzf"
    " H"  " | head"
    " H5" " | head -n5"
    " L"  " | less"
    " M"  ' ${$(git config --local init.defaultBranch):-master}'
    " P"  " | pbcopy"
    " T"  " | tail"
    " T5" " | tail -n5"
    " Q"  " 1> /dev/null"
    " QQ" " 1> /dev/null 2> /dev/null"
)

# Adapted from http://zshwiki.org/home/examples/zleiab
function magic-abbrev-expand() {
    local MATCH
    LBUFFER="${LBUFFER%%(#m) [_a-zA-Z0-9]#}"
    LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
    zle self-insert
}

zle -N magic-abbrev-expand
bindkey " " magic-abbrev-expand
