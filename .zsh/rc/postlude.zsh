if has zprof; then
    zprof | less
    echo "Profiling has finished; exitting..."
    exit
fi
