# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export GREP_OPTIONS='--color=auto'

