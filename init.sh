#!/bin/bash

# TODO: minimal install
# TODO: direnv

common_pkgs=(
    # shell-related
    "bash" # install latest
    "bash-completion"
    "tldr"
    # editing tools
    # "luarocks"
    "gawk" # required for ble.sh
    # dev tools
    "make" # required for ble.sh
    "git"
    "unzip"
    # cli tools
    "watch"
    "tree"
    "tmux"
    "fzf"
    "parallel"
    "bat"
    "curl"
    "wget"
    "jq"
    "ripgrep"
    # network tools
    "nmap"
    "iperf3"
    # monitoring tools
    "htop"
    "ncdu"
    # languages
    "python3"
    "python3-pip"
    "python3-venv"
    "golang"
)

macos_pkgs=(
    "neovim"
    "font-hasklug-nerd-font"
    "font-0xproto-nerd-font"
    "fd"
    "lazygit"
    "lsd"
    "tpm"
    "coreutils"
    "ruff"
)

debian_pkgs=()

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
    # Get the installed version of Neovim
    nvim_version=$(nvim --version | head -n 1 | awk '{print $2}')

    # Convert version to comparable format (e.g., 0.10.0 -> 00010)
    convert_version() {
        echo "$1" | awk -F. '{printf("%d%02d%02d\n", $1,$2,$3)}'
    }

    installed_version=$(convert_version "$nvim_version")
    required_version=$(convert_version "0.10.0")
    if [ "$installed_version" -lt "$required_version" ]; then
        echo "removing previously installed neovim version..."
        $(check_sudo) apt-get remove -y neovim
        echo "install latest version of neovim..."
        cd /tmp || exit 1
        curl -s -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
        $(check_sudo) tar -C /opt -xzf nvim-linux64.tar.gz
    fi
}

install_macos() {
    echo "Installing prerequisites for macOS..."

    xcode-select --install

    if ! command -v brew &>/dev/null; then
        echo "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew is already installed."
    fi

    brew install ${macos_pkgs[*]}

}

install_debian() {
    echo "Installing prerequisites for Debian-based systems..."
    export DEBIAN_FRONTEND="noninteractive"
    $(check_sudo) apt-get update
    # sudo apt-get update
    echo "updated apt cache"
    $(check_sudo) apt-get install -y ${common_pkgs[*]} ${debian_pkgs[*]}
    # sudo apt-get install -y ${common_pkgs[*]} ${debian_pkgs[*]}
    echo "installed packages"
    # install latest nvim
    # install_nvim
    # # install tpm
    # if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    #     git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    # fi
}

install_redhat() {
    echo "Installing prerequisites for Red Hat-based systems..."
    sudo yum update
    sudo yum install -y epel-release
    sudo yum install -y ${common_pkgs[*]} ${redhat_pkgs[*]}
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

# echo "Linking config files"
# dotfiles="$HOME/.dotfiles"
# conf_dir="$HOME/.config"
# mkdir -p "$conf_dir"
#
# bash
# if [ ! -L "$HOME/.bashrc" ]; then
#     [ -f "$HOME/.bashrc" ] && mv "$HOME/.bashrc" "$HOME/.bashrc.bak"
#     ln -s "$dotfiles/bash/bashrc" "$HOME/.bashrc"
# fi
#
# if [ ! -L "$HOME/.bash_profile" ]; then
#     [ -f "$HOME/.bash_profile" ] && mv "$HOME/.bash_profile" "$HOME/.bash_profile.bak"
#     ln -s "$dotfiles/bash/bash_profile" "$HOME/.bash_profile"
# fi
#
# if [ ! -L "$HOME/.blerc" ]; then
#     [ -f "$HOME/.blerc" ] && mv "$HOME/.blerc" "$HOME/.blerc.bak"
#     ln -s "$dotfiles/bash/blerc" "$HOME/.blerc"
# fi
# # nvim
# if [ ! -L "$conf_dir/nvim" ]; then
#     ln -s "$dotfiles/nvim" "$conf_dir/"
# fi
#
# # tmux
# if [ ! -L "$conf_dir/tmux" ]; then
#     ln -s "$dotfiles/tmux" "$conf_dir/"
# fi
