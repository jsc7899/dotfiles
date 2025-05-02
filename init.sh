#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

arg_link=false
arg_install=false
arg_llm=false

while [[ $# -gt 0 ]]; do
    case $1 in
    -i | --install)
        arg_install=true
        shift
        ;;
    -l | --link)
        arg_link=true
        shift
        ;;
    -m | --llm)
        arg_llm=true
        shift
        ;;
    -o | --op)
        arg_op=true
        shift
        ;;
    *)
        shift
        ;;
    esac
done

common_pkgs=(
    # shell-related
    "bash"            # install latest version of the Bourne Again SHell
    "bash-completion" # programmable completion for the Bourne Again SHell
    "direnv"          # environment switcher for the shell
    "gawk"            # GNU awk, required for ble.sh
    "make"            # GNU make, required for ble.sh
    "git"             # distributed version control system
    "unzip"           # extraction utility for ZIP archives
    "watch"           # execute a program periodically
    "tree"            # display directory tree structure
    "tmux"            # terminal multiplexer
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

# use sudo if it's installed - sometimes it's not like containers and first boot debs
check_sudo() {
    if command -v sudo &>/dev/null; then
        echo "sudo"
    else
        echo ""
    fi

}

if [ "$arg_install" = true ]; then
    if [ "$(uname)" == "Darwin" ]; then
        echo "OS is macos"
        source "$SCRIPT_DIR/init/init_macos.sh"
    elif [ "$(uname)" == "Linux" ]; then
        echo "OS is linux"
        source "$SCRIPT_DIR/init/init_linux.sh"
    else
        echo "Unsupported operating system."
        exit 1
    fi
fi

# install llm
# uv tool install --python python3.12 llm

# https://llm.datasette.io/en/stable/plugins/directory.html
llm_plugins=(
    "llm-openai-plugin"     # needed for newer openai models
    "llm-cmd"               # creates a bash command - `llm cmd undo last git commit`
    "llm-cmd-comp"          # creates a bash command inline with a alt-\
    "llm-jq"                # lets you pipe in JSON data and a prompt describing a `jq` program, then executes the generated program against the JSON.
    "llm-templates-fabric"  # https://github.com/danielmiessler/fabric: `llm -t fabric:summarize -f https://en.wikipedia.org/wiki/Application_software`
    "llm-fragments-github"  #  can load entire GitHub repositories in a single operation: `llm -f github:simonw/files-to-prompt 'explain this code'`
    "llm-docs"              # adds llm -f docs: fragment
    "llm-openai-plugin"     # needed for newer openai models
    "llm-cmd"               # creates a bash command - `llm cmd undo last git commit`
    "llm-cmd-comp"          # creates a bash command inline with a alt-\
    "llm-jq"                # lets you pipe in JSON data and a prompt describing a `jq` program, then executes the generated program against the JSON.
    "llm-templates-fabric"  # https://github.com/danielmiessler/fabric: `llm -t fabric:summarize -f https://en.wikipedia.org/wiki/Application_software`
    "llm-fragments-github"  #  can load entire GitHub repositories in a single operation: `llm -f github:simonw/files-to-prompt 'explain this code'`
    "llm-bedrock"           # https://github.com/simonw/llm-bedrock
    "llm-bedrock-anthropic" # https://github.com/sblakey/llm-bedrock-anthropic
    "llm-mlx"               # https://github.com/simonw/llm-mlx
    "llm-docs"              # adds llm -f docs: fragment
)

# install llm plugins if llm exists
if [ "$arg_llm" = true ] && (command -v llm >/dev/null 2>&1 || echo "llm not installed"); then
    echo -e "\033[0;32mUpdating llm\033[0m"
    uv tool upgrade --python python3.12 llm
    echo -e "\033[0;32mInstalling and upgrading llm plugins: ${llm_plugins[*]}\033[0m"

    # if command -v parallel >/dev/null 2>&1; then
    #     echo -e "\033[33musing parallel\033[0m"
    #     printf "%s\n" "${llm_plugins[@]}" | parallel --linebuffer --tag 'llm install -U "{}"'
    # else
    for plugin in "${llm_plugins[@]}"; do
        echo -e "\033[32m$plugin\033[0m"
        llm install -U "$plugin"
    done
    # fi

fi

if [ "$arg_op" = true ] && (command -v op >/dev/null 2>&1 || echo "op not installed"); then
    setup .env
    cat >"$HOME/.env.tmpl" <<EOF
OPENAI_API_KEY="op://employee/openai infs-risk jared/api key"
EOF
    op inject -i "$HOME/.env.tmpl" -o "$HOME"/.env
fi

if [ "$arg_link" = true ]; then
    echo "Linking config files"
    dotfiles="$HOME/.dotfiles"
    conf_dir="$HOME/.config"
    mkdir -p "$conf_dir"

    # store env vars here
    [ ! -f ~/.env ] && touch ~/.env

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

    # aider
    if [ ! -L "$HOME/.aider.conf.yml" ]; then
        ln -s "$dotfiles/ai/aider/aider.conf.yml" "$HOME/.aider.conf.yml"
    fi

fi
