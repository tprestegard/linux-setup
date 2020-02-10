function print_qsub_example

    argparse --name="print_qsub_example" --max-args=0 'h/help' -- $argv
    set USAGE "usage: print_qsub_example"

    # Help?
    if set -q _flag_h
        echo "$USAGE"
        return
    end

    echo "qsub -l arch=abcdefgh -b y sleep 10"

end
