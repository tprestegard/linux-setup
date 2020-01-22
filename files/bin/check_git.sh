#! /usr/bin/env bash


###############################################################################
# Setup #######################################################################
###############################################################################
# Colors
RED='\e[1;31m'
GREEN='\e[1;32m'
NC='\e[0m'


###############################################################################
# Utility functions ###########################################################
###############################################################################
parse_branch_result () {
    # Usage:
    local RESULT=""
    case "$1" in
        0)
            RESULT="no"
            ;;
        1)
            RESULT="uncommitted"
            ;;
        2)
            RESULT="unpushed"
            ;;
        3)
            RESULT="uncommitted and unpushed"
            ;;
        4)
            RESULT="untracked"
            ;;
        5)
            RESULT="uncommitted and untracked"
            ;;
        6)
            RESULT="unpushed and untracked"
            ;;
        7)
            RESULT="uncommitted, unpushed, and untracked"
            ;;
        *)
            echo "ERROR: input should be between 0-7."
            exit 1
            ;;
    esac
    echo "${RESULT} changes detected."
}

check_branch () {
    # Usage:
    #
    # Assumes we are already in the git repo
    local BRANCH=$1

    # Check out branch
    git checkout $BRANCH --quiet
    git fetch --quiet

    # Check for uncommitted changes
    git diff-index --quiet HEAD --
    local UNCOMMITTED=$?

    # Check for unpushed changes vs upstream
    git diff HEAD origin/$BRANCH --quiet
    local UNPUSHED=$?

    # Check for untracked files
    git ls-files --other --directory --exclude-standard | \
        sed q1 > /dev/null 2>&1
    local UNTRACKED=$?

    # Determine final status
    echo $((UNCOMMITTED*1 + UNPUSHED*2 + UNTRACKED*4))
}

check_repo () {
    # Usage: check_repo [path-to-repo]
    # If an argument is not provided, use the current directory
    if [[ -n "${1}" ]]; then
        cd "${1}"
    fi

    echo "Checking local branches in repository $(realpath ${PWD})..."
    for BRANCH in $(git branch | cut -c 3-); do
        local RESULT=$(check_branch ${BRANCH})
        local MSG="${BRANCH}: $(parse_branch_result ${RESULT})"
        if [[ "${RESULT}" -gt 0 ]]; then
            MSG="${RED}[fail]${NC} ${MSG}"
        else
            MSG="${GREEN}[passed]${NC} ${MSG}"
        fi
        echo -e "\t${MSG}"
    done
}


###############################################################################
# Main code ###################################################################
###############################################################################
#cd $HOME/linux-setup
check_repo $HOME/univa/tortuga-kit-awsadapter
