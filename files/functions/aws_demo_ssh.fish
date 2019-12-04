function aws_demo_ssh
    set SSH_KEY "$HOME/univa/navops-launch/demo/aws/.ssh/navops-launch-demo-tanner.pem"
    env SSH_AUTH_SOCK="" ssh -i $SSH_KEY $argv[1]
end
