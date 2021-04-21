#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# This should always be run last either in .bashrc or as a script in .bashrc.d
if [[ -z "$TMUX" ]]; then
    tmux has-session &> /dev/null
    if [ $? -eq 1 ]; then
      exec tmux new
      exit
    else
      exec tmux attach
      exit
    fi
fi

#export PS1='\t \u@\h \w> '
export PS1="\[\e[32m\]\t\[\e[m\] \u@\[\e[34m\]\h\[\e[m\] \w> "

# export
export PATH=~/bin:$PATH
export HISTSIZE=8000

# custom
# dir
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias cd.='cd ..'
alias cd..='cd ..'

alias -- -='cd -'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
alias ls='ls --color=auto'
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'

#custom
alias sl="slocate"
alias webshare="python3 -m http.server"
# archlinux
alias p="sudo pacman"
alias sc='sudo systemctl'
alias svim='sudo vim'
alias n='sudo netctl'
alias udb='sudo updatedb'
