if [[ -n "$TMUX" ]]; then
   cut -c3- ~/.tmux.conf | sh -s on_login
fi

[[ -s "$HOME/.volta/load.sh" ]] && source "$HOME/.volta/load.sh"
