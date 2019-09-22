function cdu
    argparse --max-args=1 'h/help' -- $argv

    set USAGE "Usage: cdu <N>, where N is the number of directories you want to go up"
    if test "$status" -ne 0
        echo "$status"
        echo "$USAGE"
        return
    else if test (count $argv) -eq 1
        if test (math "floor($argv[1])") -ne "$argv[1]"
            echo "Error: N should be an integer"
            echo "$USAGE"
            return
        else if test "$argv[1]" -lt 0
            echo "Error: N should be a positive integer"
            echo "$USAGE"
            return
        end
    end

    # If no arguments, go up one directory only
    if test (count $argv) -eq 0
        set NUMLVL 1
    else
        set NUMLVL $argv[1]
    end

    # Build command
    set CMD "cd "
    while test "$NUMLVL" -gt 0
        set CMD "$CMD""../"
        set NUMLVL (math $NUMLVL-1)
    end

    eval $CMD
end
