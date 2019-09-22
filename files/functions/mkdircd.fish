function mkdircd
    argparse --name="mkdircd" --max-args=1 'h/help' -- $argv

    if set -q _flag_h
        echo "usage: mkdircd <new_directory_path>"
        return
    else if test (count $argv) -gt 1
        echo "usage: mkdircd <new_directory_path>"
        return
    end

    mkdir -p -- "$argv[1]"
    cd "$argv[1]"
end
