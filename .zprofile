# Restore PATH clobbered by /etc/zprofile
path=(${_path} ${path})

#-- Version managers {{{ ------------------------------------------------------

has rbenv && eval "$(rbenv init -)"
typeset -U path

#-- }}} ----------------------------------------------------------------------
