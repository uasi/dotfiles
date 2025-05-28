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
    if [[ "$LBUFFER" == *" ?" ]]; then
        local query="${LBUFFER% ?}"
        echo ": Q; $query" >> ~/var/log/zsh_llm_abbrev.log

        local input="
## Context

- Target shell: zsh
- System info (generated using uname -a): $(uname -a)
- Current user: $USER
- Execution environment: Interactive shell session

## Task

Create a command to accomplish: $query
"
        local output

        if output=$(llm -f ~/.local/lib/prompts/command_generator.md "$input" 2>/dev/null); then
            echo ": A; $output" >> ~/var/log/zsh_llm_abbrev.log
            LBUFFER=$output
        else
            zle self-insert
        fi

        return
    fi

    local MATCH
    LBUFFER="${LBUFFER%%(#m) [_a-zA-Z0-9]#}"
    LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
    zle self-insert
}

zle -N magic-abbrev-expand
bindkey " " magic-abbrev-expand
