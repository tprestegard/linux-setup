#! /bin/bash

HOOKS=(
applypatch-msg
commit-msg
fsmonitor-watchman
pre-rebase
p4-pre-submit
pre-applypatch
pre-auto-gc
pre-commit
pre-merge-commit
prepare-commit-msg
post-applypatch
post-checkout
post-commit
post-index-change
post-merge
post-receive
post-rewrite
pre-push
pre-receive
push-to-checkout
sendemail-validate
update
)

# Create directory if it doesn't exist
if [[ ! -d "./hooks" ]]; then
    mkdir ./hooks
fi


# Create symlinks if they don't exist
for HOOK in "${HOOKS[@]}"; do
    if [[ ! -e "./hooks/${HOOK}" ]]; then
        ln -s ../helpers/_hook_init "hooks/${HOOK}"
    fi
done
