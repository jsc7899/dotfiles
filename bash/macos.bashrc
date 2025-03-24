#!/usr/bin/env bash
# macos
ulimit -n 65536 # ansible needs to open lots of files

# exports
export SHELL="/opt/homebrew/bin/bash"
export NOMAD_ADDR=http://192.168.1.41:4646
export SMB_PASS="$(security find-generic-password -s smb -a smbuser -w)"

# brew bash completion
# https://docs.brew.sh/Shell-Completion
if type brew &>/dev/null
then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi

# aliases
alias update='$HOME/.dotfiles/scripts/update_macos.sh'
alias start_meeting="/Users/jared/Documents/scripts/redlight.sh"
alias stop_meeting="/Users/jared/Documents/scripts/bluelight.sh"
alias tacc='ssh -i $HOME/.ssh/tacc_id_ras jsc3642@stampede2.tacc.utexas.edu'
alias reset_network="sudo route -n flush && sudo dscacheutil -flushcache"
alias tastyfish="ssh jared@tastyfish.local"
alias crawfish='ssh -i $HOME/.ssh/jcampbell7899@utexas.edu.pem -p6137 jared@crawfish.infosec.utexas.edu'
alias pssh="ssh -o StrictHostKeyChecking=false -J void-jumpbox-01 "
alias notes='vim $HOME/Documents/Notes/documentation/notes.md'
alias ansible_site="/opt/ansible/site.yaml"
alias ip_lookup="/opt/chomp/.venv/bin/python3 /opt/chomp/tsc_tools/tsc_tools.py -o --ip_lookup "
alias ip_bq="/opt/chomp/.venv/bin/python3 /opt/chomp/tsc_tools/tsc_tools.py -o --ip_quarantine"
alias mac_bq="/opt/chomp/.venv/bin/python3 /opt/chomp/tsc_tools/tsc_tools.py -o --mac_quarantine"
alias nomad_ots="ssh -t nomad-client-001 'podman run -it --rm --network=ots_network --dns=1.1.1.1 --cap-add=NET_RAW -v /opt/chomp:/opt/chomp:ro -v /opt/chompout:/opt/chompout:rw void-registry.infosec.utexas.edu/utexasiso-default /bin/bash'"
alias nmap_ots="ssh -J void-jumpbox-03 -t nomad-client-001 'sudo podman run -it --rm --network=ots_network --dns=1.1.1.1 --cap-add=NET_RAW -v /opt/chomp:/opt/chomp:ro -v /opt/chompout:/opt/chompout:rw void-registry.infosec.utexas.edu/utexasiso-scavenger:production /bin/bash'"
alias nomad_git='ansible nomad_clients,nomad_baremetal -b -m shell -a "git -C /opt/chomp pull; git -C /opt/chomptest pull"'
alias refresh_dns='$HOME/.dotfiles/scripts/refresh_dns.sh'
alias pansible='$HOME/.config/scripts/pansible.sh'
alias ans='source .venv/bin/activate.fish && source setup/.env.jared'
alias du='dust -r'
alias df='duf'
alias ls='lsd -AF'
alias cat='bat -pp'
alias vha="./site.yaml --limit=load_balancers --tags=haproxy"
alias flush_dns="sudo killall -HUP mDNSResponder"
alias rsync='/opt/homebrew/bin/rsync'
alias vpn='cd ~/.dotfiles/scripts/ocgo && ./ocgo;./reset_dns.sh'
alias gac='ai_git_commit'
alias alf='ansible-lint --fix'

# macos settings
# disable displays have separate spaces
# defaults write com.apple.spaces spans-displays -bool true && killall SystemUIServer
# move windows by holding ctrl+cmd and dragging any part of the window (not necessarily the window title)
defaults write -g NSWindowShouldDragOnGesture -bool true


