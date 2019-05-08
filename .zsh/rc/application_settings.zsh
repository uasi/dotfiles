if [[ -n "$TMUX" ]]; then
   cut -c3- ~/.tmux.conf | sh -s on_login
fi

[[ -s "$HOME/.notion/load.sh" ]] && source "$HOME/.notion/load.sh"
