function tmux_attach
    # Check if session exists on any socket
    for session_socket in (tmux_ls -s)
        set socket (echo $session_socket | sed 's/^\(.*\): .*$/\1/')
        set session (echo $session_socket | sed 's/^.*: \(.*\)$/\1/')
        if test "$session" = "$argv[1]"
            break
        end
    end
    tmux -L "$socket" attach -t "$session"
end
