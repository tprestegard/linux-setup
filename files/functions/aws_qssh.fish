function aws_qssh

    argparse --name="aws_qssh" --max-args=1 'h/help' 'r/region=?' 'k/key-name=?' 'u/username=?' 'c/clear-cache' 's/skip-cache' 'v/view-cache' -- $argv
    set USAGE "usage: aws_qssh [host-type] --region=[region] --key-name=[key-name] --username=[username] --clear-cache --skip-cache --view-cache"
    # Note that key-name is used for matching hosts in AWS, not necessarily for actual SSH

    # Argument parsing with defaults
    test -n "$argv[1]"; and set HOST_TYPE "$argv[1]"; or set HOST_TYPE "installer"
    test -n "$_flag_r"; and set REGION "$_flag_r"; or set REGION "us-west-2"
    test -n "$_flag_k"; and set KEY_NAME "$_flag_k"; or set KEY_NAME "navops-launch-demo-"(whoami)
    test -n "$_flag_u"; and set USERNAME "$_flag_u"; or set USERNAME "centos"

    # Help?
    if set -q _flag_h
        echo "$USAGE"
        return
    end

    # Cachefile processing
    set CACHEFILE "$HOME/.config/aws_qssh_config"
    if set -q _flag_v
        if test -e "$CACHEFILE"
            cat $CACHEFILE
        else
            echo "Cachefile $CACHEFILE does not exist."
        end
        return
    else if set -q _flag_c
        rm -f $CACHEFILE
        return
    end

    # Match host type to Name tag
    if echo "$HOST_TYPE" | grep -q -i -E 'installer'
        # Installer
        set HOST_STR "navops-launch-demo-"
        set JQ_KEY "installer"
    else if echo "$HOST_TYPE" | grep -q -i -E 'qmaster'
        set HOST_STR "Qmaster"
        set JQ_KEY "qmaster"
    else if echo "$HOST_TYPE" | grep -q -i -E 'compute|execd'
        set HOST_STR "Compute"
        set JQ_KEY "compute"
    else if echo "$HOST_TYPE" | grep -q -i -E 'unisight|monitoring'
        set HOST_STR "Unisight"
        set JQ_KEY "unisight"
    else
        set HOST_STR "$HOST_TYPE"
    end

    # Is hostname cached? If so, look it up
    if test -e "$CACHEFILE"
       and test -n "$JQ_KEY"
       and not set -q _flag_s
        set HOSTNAME (jq -r --arg JKEY "$JQ_KEY" '.[$JKEY]' $CACHEFILE)
    end

    # Look up hostname using AWS API
    set CACHE_HOSTNAME 0
    if test -z "$HOSTNAME"
       or test "$HOSTNAME" = "null"
        #set HOSTNAME (aws --region=$REGION ec2 describe-instances \
        #    --filter Name=key-name,Values=$KEY_NAME Name=instance-state-name,Values=running \
        #    --query 'Reservations[*].Instances[*].{Instance:PublicDnsName,Name:Tags[?Key==`Name`]|[0].Value}' |\
        #    jq -r --arg HOST_STR $HOST_STR '.[] | .[0] | select(.Name | contains($HOST_STR)).Instance')
        set HOSTNAME (aws --region=$REGION ec2 describe-instances \
            --filter Name=key-name,Values=$KEY_NAME Name=instance-state-name,Values=running \
            --query 'Reservations[*].Instances[*].{Value:PublicDnsName,Name:Tags[?Key==`Name`]|[0].Value}' |\
            jq -r --arg HOST_STR $HOST_STR '[add | .[] | select(.Name | contains($HOST_STR)) | select(.Value != "").Value][0]')
        if test -z $HOSTNAME
            echo "Host not found."
            return 1
        end
        set CACHE_HOSTNAME 1
    end

    # Add info to cache file
    if test "$CACHE_HOSTNAME" -eq 1
       and test -n "$JQ_KEY"
       and not set -q _flag_s
        if test -e "$CACHEFILE"
            set TEMPFILE (mktemp)
            jq --arg HOSTNAME "$HOSTNAME" --arg JKEY "$JQ_KEY" '. + {($JKEY): $HOSTNAME}' $CACHEFILE > $TEMPFILE \
                && mv $TEMPFILE $CACHEFILE && rm -f $TEMPFILE
        else
            jq -n --arg HOSTNAME "$HOSTNAME" --arg JKEY "$JQ_KEY" '{($JKEY): $HOSTNAME}' > $CACHEFILE
        end
    end

    demo_ssh aws $USERNAME@$HOSTNAME
end
