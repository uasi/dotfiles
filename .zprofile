# Restore PATH clobbered by /etc/zprofile
path=(${_path} ${path})
typeset -U PATH

#-- Version managers {{{ ------------------------------------------------------

if [[ -s $PERLBREW_ROOT/etc/bashrc ]]; then
    source $PERLBREW_ROOT/etc/bashrc
fi

if [[ -s $HOME/.pythonz/etc/bashrc ]]; then
    source $HOME/.pythonz/etc/bashrc
fi

has rbenv && eval "$(rbenv init -)"
typeset -U path

#-- }}} ----------------------------------------------------------------------
