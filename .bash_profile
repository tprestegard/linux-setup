# Simple .bash_profile, basically only used by tmux sessions.

# Source .profile (if it exists), which then sources .bashrc on its own.
if [ -f ${HOME}/.profile ]; then
    . ${HOME}/.profile
fi
