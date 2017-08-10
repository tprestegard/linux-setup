# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# Import functions and set $TERM (for Ubuntu).
# For Debian, we have to do this in .bashrc.
if [[ $(lsb_release -si) != "Debian" ]]; then
    # set PATH so it includes user's private bin if it exists
    if [[ -d "$HOME/bin" ]] ; then
        export PATH="$HOME/bin:$PATH"
    fi
    if [[ -r "$HOME/.functions" ]] && [[ -f "$HOME/.functions" ]]; then
        source "$HOME/.functions"
    fi
    # Set TERM to be xterm-256color
    if [[ "$TERM" == "xterm" ]]; then
        export TERM=xterm-256color
    fi
    # Custom prompt
    if [[ -f "$HOME/bin/prompt" ]]; then
        source $HOME/bin/prompt
    fi
    # Export editor
    if [[ ! -z $(which vim) ]]; then
        export EDITOR=$(which vim)
    fi
fi

# Source .bashrc if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [[ -f "$HOME/.bashrc" ]]; then
        . "$HOME/.bashrc"
    fi
fi

