function gcp_rsync

    set IP "$argv[1]"
    set SRC_DIR "$argv[2]"
    set TARGET_DIR "$argv[3]"
    test -n "$argv[4]"; and set USERNAME "$argv[4]"; or set USERNAME "root"
    set SSH_KEY "$HOME/.ssh/id_rsa_univa"

    rsync -av --delete -e "ssh -i $SSH_KEY" $SRC_DIR "$USERNAME@$IP:$TARGET_DIR"
end
