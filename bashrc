# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

HISTCONTROL=ignoreboth:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

HISTSIZE=1000
HISTFILESIZE=2000
HISTTIMEFORMAT="%d %h %H:%M:%S> "

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

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Set editor to some kind flavor of Vi, preferring NeoVim if it's available
if [ -x $(which nvim) ]; then
  export EDITOR=nvim
  export GIT_EDITOR='nvim -f'
elif [ -x $(which vim) ]; then
  export EDITOR=vim
  export GIT_EDITOR='vim -f'
elif [ -x $(which vi) ]; then
  export EDITOR=vi
  export GIT_EDITOR='vi -f'
fi

bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'

export PATH=~/.local/bin:$PATH

export PS1="\n\[\033[2;37m\]\h:\[\033[00m\]\w\n\$(git-prompt)\$\[\033[00m\] "

# Set up Node Version Manager, if it's installed
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

