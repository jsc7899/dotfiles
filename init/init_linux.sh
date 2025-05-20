#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/packages.sh"

install_debian() {
    echo "Installing prerequisites for Debian-based systems..."
    export DEBIAN_FRONTEND="noninteractive"
    $(check_sudo) apt-get update
    echo "updated apt cache"
    $(check_sudo) apt-get install -y "${common_pkgs[@]}" "${debian_pkgs[@]}"
    echo "installed packages"
}

install_redhat() {
    echo "Installing prerequisites for Red Hat-based systems..."
    sudo yum update
    sudo yum install -y epel-release
    sudo yum install -y "${common_pkgs[@]}" "${redhat_pkgs[@]}"
}

install_fzf() {
    echo "installing fzf via apt"
    $(check_sudo) apt remove -y fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME"/.fzf
    "$HOME"/.fzf/install --all
}

install_nvim() {
    # Check if nvim is installed
    if command -v nvim &>/dev/null; then
        nvim_installed=true
        # Get the installed version of Neovim
        nvim_version="0.11.1"
        cur_version=$(nvim --version | head -n 1 | awk '{print $2}')

        # Convert version to comparable format (e.g., 0.10.0 -> 00010)
        convert_version() {
            echo "$1" | awk -F. '{printf("%d%02d%02d\n", $1,$2,$3)}'
        }

        installed_version=$(convert_version "$cur_version")
        required_version=$(convert_version "$nvim_version")
    else
        nvim_installed=false
    fi

    if [ "$nvim_installed" = false ] || [ "$installed_version" -lt "$required_version" ]; then
        echo "Removing previously installed Neovim version..."
        $(check_sudo) apt-get remove -y neovim
        echo "Installing latest version of Neovim..."
        cd /tmp || exit 1
        curl -s -LO "https://github.com/neovim/neovim/releases/download/v$nvim_version/nvim-linux-x86_64.tar.gz"
        $(check_sudo) tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    fi
}

install_op() {
    # https://developer.1password.com/docs/cli/get-started
    curl -sS https://downloads.1password.com/linux/keys/1password.asc |
        $(check_sudo) gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg &&
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" |
        $(check_sudo) tee /etc/apt/sources.list.d/1password.list &&
        $(check_sudo) mkdir -p /etc/debsig/policies/AC2D62742012EA22/ &&
        curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol |
        $(check_sudo) tee /etc/debsig/policies/AC2D62742012EA22/1password.pol &&
        $(check_sudo) mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22 &&
        curl -sS https://downloads.1password.com/linux/keys/1password.asc |
        $(check_sudo) gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg &&
        $(check_sudo) apt update && $(check_sudo) apt install 1password-cli
}

if [[ -f /etc/debian_version ]]; then
    echo "OS is debian"
    install_debian
    if [ ! -d "$HOME"/.fzf ]; then
        install_fzf
    fi
    install_nvim
    install_op
elif [[ -f /etc/redhat-release ]]; then
    echo "OS is redhat"
    install_redhat
else
    echo "Unsupported linux operating system."
    exit 1
fi
