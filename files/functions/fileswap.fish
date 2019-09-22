function fileswap
    argparse --name="fileswap" --max-args=2 'h/help' -- $argv
    set USAGE "usage: fileswap <file1> <file2>"

    if set -q _flag_h
        echo "$USAGE"
        return
    else if test (count $argv) -ne 2
        echo "fileswap takes exactly 2 arguments"
        echo "$USAGE"
        return
    end

    set TEMP_FILE "/tmp/tmp."(random)
    mv "$argv[1]" "$TEMP_FILE"
    mv "$argv[2]" "$argv[1]"
    mv "$TEMP_FILE" "$argv[2]"
end
