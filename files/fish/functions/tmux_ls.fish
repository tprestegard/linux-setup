function tmux_ls
    argparse 'h/help' 's/short' -- $argv
    for socket in (tmux_sockets)
        if set -q _flag_s
            set session_details (tmux -L $socket list-sessions | sed 's/^\(.*\): .*/\1/')
        else
            set session_details (tmux -L $socket list-sessions)
        end
        for output in $session_details
            echo "$socket: $output"
        end
    end
end
