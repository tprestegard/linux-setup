function savedir
    argparse 'h/help' 's/show' 'g/go' -- $argv

    set USAGE "\
Usage: savedir [--show] [--go]
  Saves current directory in a specific file ($HOME/.config/.fish_savedir)
  so it can be referenced from other sessions."

    # Help?
    if set -q _flag_h
        echo "$USAGE"
        return
    end

    # File path
    set FILE_PATH "$HOME/.config/.fish_savedir"

    # Print current dir?
    if set -q _flag_s
        if test -e "$FILE_PATH"
            cat $FILE_PATH
        else
            echo "Save file $FILE_PATH does not exist."
        end
        return
    else if set -q _flag_g
        if test -e "$FILE_PATH"
            cd (cat $FILE_PATH)
        else
            echo "Save file $FILE_PATH does not exist."
        end
        return
    end 

    pwd > $FILE_PATH
end
