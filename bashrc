#
# ~/.bashrc
#

# Load aliases
source ~/.bash_aliases

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export PATH=~/.bin:$PATH
