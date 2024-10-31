#!/bin/bash

common_pkgs=(
    # shell-related
    "bash"            # install latest version of the Bourne Again SHell
    "bash-completion" # programmable completion for the Bourne Again SHell
    "tldr"            # simplified and community-driven man pages
    "direnv"          # environment switcher for the shell
    "gawk"            # GNU awk, required for ble.sh
    "make"            # GNU make, required for ble.sh
    "git"             # distributed version control system
    "unzip"           # extraction utility for ZIP archives
    "watch"           # execute a program periodically
    "tree"            # display directory tree structure
    "tmux"            # terminal multiplexer
    "fzf"             # command-line fuzzy finder
    "parallel"        # command-line CPU load balancer
    "bat"             # cat clone with syntax highlighting
    "curl"            # command-line tool for transferring data with URLs
    "wget"            # network utility to retrieve files from the web
    "jq"              # lightweight and flexible command-line JSON processor
    "ripgrep"         # line-oriented search tool
    "nmap"            # network exploration tool and security scanner
    "iperf3"          # tool for measuring TCP, UDP, and SCTP bandwidth performance
    "htop"            # interactive resources viewer
)

macos_pkgs=(
    "neovim"                 # text editor
    "font-hasklug-nerd-font" # font for terminal
    "font-0xproto-nerd-font" # font for terminal
    "fd"                     # find alternative
    "lazygit"                # git terminal UI
    "lsd"                    # ls alternative
    "tpm"                    # tmux plugin manager
    "coreutils"              # basic file, shell utilities
    "ruff"                   # network troubleshooting
    "ansible-lint"           # linting for Ansible
    "httpie"                 # HTTP client
    "tlxs"                   # TLS scanner
    "httpx"                  # HTTP discovery
    "naabu"                  # port scanner
    "hyperfine"              # measure runtime
    "dust"                   # du alternative
    "duf"                    # df alternative
)

debian_pkgs=(
    "python3-pip"
    "python3-venv"
)

redhat_pkgs=()

# use sudo if it's installed - sometimes it's not like containers and first boot debs
check_sudo() {
    if command -v sudo &>/dev/null; then
        echo "sudo"
    else
        echo ""
    fi

}

install_nvim() {
    # Check if nvim is installed
    if command -v nvim &>/dev/null; then
        nvim_installed=true
        # Get the installed version of Neovim
        nvim_version=$(nvim --version | head -n 1 | awk '{print $2}')

        # Convert version to comparable format (e.g., 0.10.0 -> 00010)
        convert_version() {
            echo "$1" | awk -F. '{printf("%d%02d%02d\n", $1,$2,$3)}'
        }

        installed_version=$(convert_version "$nvim_version")
        required_version=$(convert_version "0.10.0")
    else
        nvim_installed=false
    fi

    if [ "$nvim_installed" = false ] || [ "$installed_version" -lt "$required_version" ]; then
        echo "Removing previously installed Neovim version..."
        $(check_sudo) apt-get remove -y neovim
        echo "Installing latest version of Neovim..."
        cd /tmp || exit 1
        curl -s -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
        $(check_sudo) tar -C /opt -xzf nvim-linux64.tar.gz
    fi
}
install_macos() {
    echo "Installing prerequisites for macOS..."

    xcode-select --install

    if [ ! -d "/opt/homebrew" ]; then
        echo "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew is already installed."
    fi

    brew update
    brew upgrade
    brew install "${common_pkgs[@]}"
    brew install "${macos_pkgs[@]}"
    brew cleanup
    brew doctor
}

install_debian() {
    echo "Installing prerequisites for Debian-based systems..."
    export DEBIAN_FRONTEND="noninteractive"
    $(check_sudo) apt-get update
    echo "updated apt cache"
    $(check_sudo) apt-get install -y "${common_pkgs[@]}" "${debian_pkgs[@]}"
    echo "installed packages"
    # install latest nvim
    install_nvim
}

install_redhat() {
    echo "Installing prerequisites for Red Hat-based systems..."
    sudo yum update
    sudo yum install -y epel-release
    sudo yum install -y "${common_pkgs[@]}" "${redhat_pkgs[@]}"
}

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "OS is macos"
    install_macos
elif [[ -f /etc/debian_version ]]; then
    echo "OS is debian"
    install_debian
elif [[ -f /etc/redhat-release ]]; then
    install_redhat
    echo "OS is redhat"
else
    echo "Unsupported operating system."
    exit 1
fi

echo "Linking config files"
dotfiles="$HOME/.dotfiles"
conf_dir="$HOME/.config"
mkdir -p "$conf_dir"

# bash
if [ ! -L "$HOME/.bashrc" ]; then
    [ -f "$HOME/.bashrc" ] && mv "$HOME/.bashrc" "$HOME/.bashrc.bak"
    ln -s "$dotfiles/bash/bashrc" "$HOME/.bashrc"
fi

if [ ! -L "$HOME/.bash_profile" ]; then
    [ -f "$HOME/.bash_profile" ] && mv "$HOME/.bash_profile" "$HOME/.bash_profile.bak"
    ln -s "$dotfiles/bash/bash_profile" "$HOME/.bash_profile"
fi

if [ ! -L "$HOME/.blerc" ]; then
    [ -f "$HOME/.blerc" ] && mv "$HOME/.blerc" "$HOME/.blerc.bak"
    ln -s "$dotfiles/bash/blerc" "$HOME/.blerc"
fi
# nvim
if [ ! -L "$conf_dir/nvim" ]; then
    ln -s "$dotfiles/nvim" "$conf_dir"
fi

# tmux
if [ ! -L "$HOME/.tmux.conf" ]; then
    ln -s "$dotfiles/tmux/tmux.conf" "$HOME/.tmux.conf"
fi

# create default venv if it does not exist
if [ ! -d "$HOME/.dotfiles/.venv" ]; then
    python3 -m venv "$HOME/.dotfiles/.venv"
fi
source "$HOME/.dotfiles/.venv/bin/activate"
pip install -r "$HOME/.dotfiles/config/requirements.txt"
deactivate
