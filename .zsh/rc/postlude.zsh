if [[ "${ZSH_PROFILE:+x}" = x ]]; then
    zprof | less
    echo "Profiling has finished; exitting..."
    exit
fi
