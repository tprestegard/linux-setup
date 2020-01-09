function demo_ssh_or_scp

    set cmd "$argv[1]"
    test -n "$argv[2]"; and set CLOUD_PROVIDER "$argv[2]"; or set CLOUD_PROVIDER "aws"
    if test "$CLOUD_PROVIDER" = "aws"
        set KEY_NAME "navops-launch-demo-tanner.pem"
    else if test "$CLOUD_PROVIDER" = "azure"
        set KEY_NAME "id_rsa"
    else
        echo "error: cloud provider should be 'aws' or 'azure'"
        return 1
    end
    set SSH_KEY "$HOME/univa/navops-launch/demo/$CLOUD_PROVIDER/.ssh/$KEY_NAME"
    $cmd -o IdentitiesOnly=yes -i $SSH_KEY $argv[3..-1]
end
