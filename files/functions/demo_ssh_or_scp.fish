function demo_ssh_or_scp

    set cmd "$argv[1]"
    test -n "$argv[2]"; and set CLOUD_PROVIDER "$argv[2]"; or set CLOUD_PROVIDER "aws"
    if test "$CLOUD_PROVIDER" = "aws"
        set SSH_KEY (ls $HOME/univa/navops-launch/demo/aws/.ssh/*.pem | head -1)
    else if test "$CLOUD_PROVIDER" = "azure"
        set SSH_KEY (ls $HOME/univa/navops-launch/demo/azure/.ssh/id_rsa)
    else
        echo "error: cloud provider should be 'aws' or 'azure'"
        return 1
    end
    $cmd -o IdentitiesOnly=yes -i $SSH_KEY $argv[3..-1]
end
