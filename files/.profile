# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Add /usr/local/sbin to PATH if it exists.
if [ -d /usr/local/sbin ] ; then
    PATH="/usr/local/sbin:$PATH"
fi

# Add /usr/local/lib to LD_LIBRARY_PATH
if [ -d /usr/local/lib ] ; then
    export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# Set environment variables (if needed)
# Bash history file size.
HISTFILESIZE=1000

