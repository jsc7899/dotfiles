#!/usr/bin/env bash

# Package lists used by init scripts

common_pkgs=(
    # shell-related
    "bash"
    "bash-completion"
    "direnv"
    "gawk"
    "make"
    "git"
    "unzip"
    "watch"
    "tree"
    "tmux"
    "parallel"
    "bat"
    "curl"
    "wget"
    "jq"
    "ripgrep"
    "nmap"
    "iperf3"
    "htop"
    "zoxide"
)

debian_pkgs=(
    "python3-pip"
    "python3-venv"
    "ansible-lint"
    # "lazygit"
    "shellcheck"
)

redhat_pkgs=()

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
    "ansible-lint"
    "httpie"
    "tlsx"
    "httpx"
    "naabu"
    "hyperfine"
    "dust"
    "duf"
    "fzf"
    "uv"
    "highlight"
    "op"
    "sesh"
)
