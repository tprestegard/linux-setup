# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
#[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# My stuff --------------------------------------------------

# Set TERM to be xterm-256color
if [ "$TERM" == "xterm" ]; then
    export TERM=xterm-256color
fi

# Set up prompt.
source ${HOME}/bin/prompt
PROMPT_COMMAND='PS1=`_theme_distinguished` add_venv_info'

# Set up virtualenvwrapper                                                  
if [[ -f /usr/local/bin/virtualenvwrapper.sh ]]; then
	source /usr/local/bin/virtualenvwrapper.sh
fi

# Other setup
# Up arrow to complete history.
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
# Extended pattern matching.
shopt -s extglob

# Aliases.
alias lh='ls -lh'
alias emacs='emacs -nw'
alias theme='source theme' # allows theme to be changed on-the-fly

# UWM VPN
oc () { sudo openconnect -u prestega --juniper vpn.uwm.edu -b --no-cert-check; }

# SSH functions ---------------
# UMN physics computers.
luts () { ssh -Y lutsen.spa.umn.edu ; }
matt () { ssh -Y matterhorn.spa.umn.edu ; }

# LIGO computers
ligo_setup () { source ${HOME}/bin/ligo-setup.sh; }
pcdev () { ligo_setup; gsissh -Y ldas-pcdev$1.ligo.caltech.edu; }
pcgrid () { ligo_setup; gsissh -Y ldas-grid.ligo.caltech.edu; }
atlas () { ligo_setup; gsissh -Y atlas$1.atlas.aei.uni-hannover.de; }
titan () { ligo_setup; gsissh -Y titan$1.atlas.aei.uni-hannover.de; }
lho () { ligo_setup; gsissh -Y ldas-pcdev$1.ligo-wa.caltech.edu; }
llo () { ligo_setup; gsissh -Y ldas-pcdev$1.ligo-la.caltech.edu; }
uwm () { ligo_setup; gsissh -Y pcdev$1.phys.uwm.edu; }
sugar () { ligo_setup; gsissh -Y sugar-dev2.phy.syr.edu; }

# UWM computers
gdb () { ssh -A gracedb.cgca.uwm.edu; }
gdb-test () { ssh -A gracedb-test.cgca.uwm.edu; }
sdb () { ssh -A simdb.cgca.uwm.edu; }
lva () { ssh -A lvalert.cgca.uwm.edu; }
lva-test () { ssh -A lvalert-test.cgca.uwm.edu; }
ligo-rm () { ssh -A ligo-rm.phys.uwm.edu; }
dashboard () { ssh -A dashboard.cgca.uwm.edu; }
# Sandboxes
webhook () { ssh -A webhook-test.cgca.uwm.edu; }
eah () { ssh -A eah-d8-dev.cgca.uwm.edu; }
