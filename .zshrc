# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
# source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting zsh-autosuggestions colored-man-pages common-aliases macos brew kubectl)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias chomp1="ssh -i ~/.ssh/jcampbell7899@utexas.edu.pem jared@security-scanner-ch0001.infosec.utexas.edu"
alias chomp2="ssh -i ~/.ssh/jcampbell7899@utexas.edu.pem jared@security-scanner-ch0002.infosec.utexas.edu"
alias sysmgmt-test="ssh jared@sysmgmt-test.infosec.utexas.edu"
alias risk-students="ssh jared@risk-students.infosec.utexas.edu"
alias pi4="ssh jared@pi4.local"
alias pi3="ssh pi@pi3.local"
alias update="brew update && brew upgrade && brew upgrade --cask && brew cleanup && brew autoremove && brew doctor"
alias gp_ec2="ssh -i "~/.ssh/gp_ec2.pem" ubuntu@ec2-52-87-232-112.compute-1.amazonaws.com"
alias barbatos="ssh jared@barbatos.local" 
alias sandbox="ssh jared@146.6.161.123"
alias exia="ssh jared@exia.infosec.utexas.edu"
alias tacc="ssh -i ~/.ssh/tacc_id_ras jsc3642@stampede2.tacc.utexas.edu"
# alias cat="~/.cat"
alias chomp_kinit="sudo kinit -kt /etc/security/keytabs/chomp.headless.keytab chomp"
alias ip_lookup="ssh -t jared@security-scanner-ch0001.infosec.utexas.edu sudo /opt/chomp/tsc_tools/tsc_tools.py -o --ip_lookup "
alias ip_bq="ssh -t jared@security-scanner-ch0001.infosec.utexas.edu sudo /opt/chomp/tsc_tools/tsc_tools.py -o --ip_quarantine "
alias mac_bq="ssh -t jared@security-scanner-ch0001.infosec.utexas.edu sudo /opt/chomp/tsc_tools/tsc_tools.py -o --mac_quarantine "
alias eid_bq="ssh -t jared@security-scanner-ch0001.infosec.utexas.edu sudo /opt/chomp/tsc_tools/tsc_tools.py -o --eid_quarantine "
alias reset_network="sudo route -n flush && sudo dscacheutil -flushcache"
alias start_meeting="/Users/jared/Documents/scripts/redlight.sh"
alias stop_meeting="/Users/jared/Documents/scripts/bluelight.sh"
alias tastyfish="ssh jared@tastyfish.local"
alias nmap_ots="ssh -t -i ~/.ssh/jcampbell7899@utexas.edu.pem jared@security-scanner-ch0005.infosec.utexas.edu '/usr/bin/docker run -it --rm --network ots_network -v /etc/krb5.conf:/etc/krb5.conf:ro -v /tmp/krb5cc_0:/tmp/krb5cc_0:ro -v /opt/chomp:/opt/chomp:ro -v /opt/chompout:/opt/chompout:rw --name nmap_ots_jared_\$RANDOM --hostname nmap_ots utexasiso/nmap:latest'"
alias ks='kubectl -n kube-system'
alias cat='bat -pp'
alias ls='lsd'
alias du='dust'
# unalias duf
alias df='duf'
alias grep='rg'
alias proxmox="ssh root@proxmox.local"
alias htpc="ssh -i ~/.ssh/jared_home -p 2225 root@192.168.2.159"
alias tig="ssh -i ~/.ssh/jared_home -p 2223 root@192.168.2.159"
alias unifi="ssh -i ~/.ssh/jared_home -p 2224 root@192.168.2.159"
alias ks="kubectl -n kube-system"
alias dc="docker-compose"
alias oci="ssh ubuntu@144.24.61.0"
alias void="ssh 192.168.2.159"

# alias chomp="~/Documents/ssh_alias.sh"

# ctrl+space goes forward one word in autocomplete
bindkey '^ ' forward-word

# functions
chomp () {
	ssh -i ~/.ssh/jcampbell7899@utexas.edu.pem jared@security-scanner-ch00$1.infosec.utexas.edu
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Custom syntax highlighting color
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=cyan,underline
ZSH_HIGHLIGHT_STYLES[precommand]=fg=cyan,underline
ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan

export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/curl/bin:$PATH"
export PATH="$PATH:/Users/jared/Library/Python/3.9/bin"
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES

# brew completions
if type brew &>/dev/null; then
	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
	autoload -Uz compinit
	compinit
fi

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

