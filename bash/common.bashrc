#!/usr/bin/env bash

# fix terminal/tmux for undercurl support - squigly line for errors
# see https://dev.to/jibundit/undercurl-display-on-neovim-and-tmux-with-iterm2-3pi0
export TERM="xterm-256color"
tic -x ~/.dotfiles/config/xterm-256color.ti

## PATH ##
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$PATH:/opt/nvim-linux64/bin"
export PATH="$PATH:/Library/NessusAgent/run/sbin"
export PATH="$PATH:$HOME/.dotfiles/scripts"
export PATH="/Users/jared/.local/bin:$PATH" # uv

## Update Dotfiles ##
if [ -d "$HOME/.dotfiles" ]; then
    if [ ! -f "$HOME/.dotfiles/.ts" ]; then
        touch "$HOME/.dotfiles/.ts"
    fi
    # if file is older than one hour
    if find ~/.dotfiles/.ts -mmin 60 | grep ts; then
        git -C "$HOME/.dotfiles" pull >/dev/null
    fi
fi

## BLE.SH ##
# https://github.com/akinomyoga/ble.sh/wiki/Manual-%C2%A71-Introduction
# install ble.sh if needed
if [ ! -f "$HOME/.local/share/blesh/ble.sh" ]; then
    git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git /tmp/ble.sh
    make -C /tmp/ble.sh install PREFIX="$HOME/.local"
fi
# source ble.sh and config
[[ $- == *i* ]] &&
source "$HOME/.local/share/blesh/ble.sh" --rcfile "$HOME/.blerc" --noattach

set -o vi # use vi mode for bash keys
# set -o emacs # use emacs mode (default) for bash keys

## EXPORT ##
export EDITOR=nvim
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY="YES"

if command -v security &>/dev/null; then
    OPENAI_API_KEY=$(security find-generic-password -s openai -a autocomplete -w)
else
    source ~/.env
fi
export OPENAI_API_KEY

## Functions ##
source "$HOME/.dotfiles/bash/functions"
source "$HOME/.dotfiles/bash/llm-cmd-comp.bash"

## GO config ##
export GOPATH="$HOME/go"
export GOCACHE="$HOME/.cache/go"
export GOMAXPROCS=$(nproc)
export PATH="$PATH:$GOPATH/bin"

## ALIAS ##
# common
alias ls='ls -F --color=auto'
alias ll='ls -larthF'
alias gs="git status"
alias ks='kubectl -n kube-system'
# alias grep='rg'
alias cat='batcat -pp'
alias diff='colordiff -y --suppress-common-lines'
alias lg='lazygit'
alias x='exit'
alias ta='tmux a -t'
alias v='nvim'
alias jq='jq -C'
alias less='less -R'
alias gb='go build -v'
alias rb='exec bash' # reload bash
alias gpl='git pull'
alias gph='git push'
alias sshkeygen='ssh-keygen -t ed25519 -a 100'
alias makepasswd='openssl passwd -6 --salt'
alias tput.sh='~/.dotfiles/scripts/tput.sh'
alias colors='/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/gawin/bash-colors-256/master/colors)"'
alias node_elig='nomad node eligibility # -self -enable -disable'
alias nomad_run='cd /opt/ansible && sleep 1 && ansible nomad_clients -b -m shell -a'
alias nomad_secrets='cd /opt/ansible && /opt/ansible/plays/void/nomad/nomad_clients.yaml --tags=secrets --limit=nomad_clients && cd -'
alias +x='chmod +x'
# llm
alias bashllm='llm -m o3-mini -o reasoning_effort low --system \
    "You are an expert in Bash scripting and Linux command-line operations. Your goal is to provide clear, accurate, and efficient solutions to user queries about accomplishing tasks in Bash." '
alias ansiblellm='llm -m o3-mini -o reasoning_effort low --system \
    "You are an expert in Ansible. Your goal is to write Ansible tasks. Only output the task. Use fully qualified module names and lint appropriately ." '

# attach to tmux on SSH
if [[ -z $TMUX ]] && [[ -n $SSH_TTY ]]; then
    exec tmux new-session -A -s main
fi

# load direnv
eval "$(direnv hook bash)"

# set up fzf key bindings and fuzzy completion
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# needs to be at end of file
[[ ! ${BLE_VERSION-} ]] || ble-attach
