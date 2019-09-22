function tmux_new
    argparse 'h/help' -- $argv
    if set -q _flag_help; or test (count $argv) -ne 1
        echo "Usage: tn <session_name>"
        return
    end

    # Check if a session with the same name already exists on any socket; if so, fail
    set EXISTING_SESSIONS (tmux_ls -s | sed 's/^.*: \(.*\)$/\1/')
    if contains "$argv[1]" $EXISTING_SESSIONS
        echo "Session" "$argv[1]" "already exists."
        return
    end

    # Make sure we aren't using a socket that is in use
    set EXISTING_SOCKETS (tmux_sockets)
    set SOCKET (random)
    while contains $SOCKET $EXISTING_SOCKETS
        set SOCKET (random)
    end

    tmux -L $SOCKET new -s "$argv[1]"
end
