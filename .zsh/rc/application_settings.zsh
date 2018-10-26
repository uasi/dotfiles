if [[ -n "$TMUX" ]]; then
   cut -c3- ~/.tmux.conf | sh -s on_login
fi
