function tmux_sockets
    for socket in (lsof -U 2> /dev/null | grep tmux-1000/ | sed 's/.*tmux-1000\/\([0-9]*\) .*/\1/' | uniq)
        echo $socket
    end
end
