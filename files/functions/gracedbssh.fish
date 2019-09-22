function gracedbssh
    # Defaults
    set DOMAIN "ligo.org"
    set HOSTNAME_BASE "gracedb"

    # Usage
    set USAGE "\
gracedbssh <suffix> [-g]

  The suffix is the part of the hostname following 'gracedb-', if any;
    i.e., use 'dev1' to connect to gracedb-dev1.ligo.org.
  The -g option connects to the 'gracedb' account instead of your
    personal account.

  Example: gracedbssh dev2 -g"

    # Parse arguments
    argparse --name=gracedbssh --max-args=1 'h/help' 'g' -- $argv
    if test "$status" -ne 0
        echo $USAGE
        return
    end

    # Check arguments
    if set -q _flag_help
        echo -e "$USAGE"
        return
    end

    # Process arguments
    # User account
    if set -q _flag_g
        set GRACEDB_USER "gracedb@"
    else
        set GRACEDB_USER ""
    end

    # Hostname suffix
    if test (count $argv) -eq 0
        set HOSTNAME_SUFFIX ""
    else
        set HOSTNAME_SUFFIX "-$argv[1]"
    end
    set HOST "$HOSTNAME_BASE$HOSTNAME_SUFFIX.$DOMAIN"

    ssh -YA $GRACEDB_USER$HOST
end
