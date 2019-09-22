function etox
    # Usage
    set USAGE "Usage: etox <env_name_matching_string>"

    # Parse arguments
    argparse --name=etox -s 'h/help' -- $argv

    if set -q _flag_help
        echo $USAGE
        return
    end

    # Handle extra arguments
    if test (count $argv) -gt 1
        set TOX_ARGS "$argv[2..-1]"
    end

    set TOX_ENV_LIST (tox -l | grep "$argv[1]" | paste -sd "," -)
    tox "$TOX_ARGS" -e "$TOX_ENV_LIST"
end
