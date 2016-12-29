# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# My stuff --------------------------------------------------

# Set up prompt.
#source $HOME/bin/prompt
if [[ -f "$HOME/bin/prompt" ]]; then
	export PROMPT_COMMAND='PS1=`_theme_random_color_xtreme `'
else
	# Default prompt
	titlebar="\[\e]2;\u@\h \w\a\]"
	user="\[\e[1;35m\]\u\[\e[m\]@\[\e[1;33m\]\h\[\e[m\]"
	path_list="\[\e[1;31m\]\w\[\e[m\]"
	export PS1="${titlebar}[${user}:${path_list}]\$ "
fi

# Other setup
# Arrow keys to complete history.
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
# Extended pattern matching.
shopt -s extglob

# Aliases.
alias lh='ls -lh'
alias emacs='emacs -nw'
if [[ -f "$HOME/bin/theme" ]]; then
	alias theme='source theme' # allows theme to be changed on-the-fly
fi
# sudo/su environment aliases
alias sudoE='sudo -E '
alias sup='su -p'

# Import functions (Debian)
if [[ $(lsb_release -si) == "Debian" ]]; then
	if [[ -r "$HOME/.functions" ]] && [[ -f "$HOME/.functions" ]]; then
		source "$HOME/.functions"
	fi
fi

