#!/usr/bin/env bash
set -euo pipefail

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
    "tlsx"                   # TLS scanner
    "httpx"                  # HTTP discovery
    "naabu"                  # port scanner
    "hyperfine"              # measure runtime
    "dust"                   # du alternative
    "duf"                    # df alternative
    "fzf"                    # command-line fuzzy finder
    "uv"                     # python package manager
)

install_macos() {
    echo "Installing prerequisites for macOS..."

    if [[ ! -d $(xcode-select -p) ]]; then
        xcode-select --install
    else
        echo "xcode is already installed."
    fi

    if [[ ! -d "/opt/homebrew" ]]; then
        echo "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew is already installed."
    fi

    echo "Now updating and upgrading homebrew pkgs..."
    brew update
    brew upgrade
    echo "Installing common homebrew pkgs..."
    brew install "${common_pkgs[@]}"
    echo "Installing macos-specific homebrew pkgs..."
    brew install "${macos_pkgs[@]}"
    echo "Cleaning up homebrew"
    brew cleanup
    brew doctor
}

# todo fix for macos
# $(check_sudo) chown -R jared:staff ~/
install_macos
