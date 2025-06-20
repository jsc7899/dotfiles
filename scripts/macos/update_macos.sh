#!/bin/bash

# Color variables
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Functions for each section
update_brew() {
    echo -e "\n${GREEN}Updating brew packages ...${NC}"
    brew update
    brew upgrade

    echo -e "\n${GREEN}Upgrading cask packages ...${NC}"
    for cask in $(brew list --cask | grep --invert-match "slack\|firefox\|pycharm"); do
        brew upgrade --cask --greedy "$cask"
    done

    brew cleanup
    brew autoremove
    brew doctor
}

update_local_pip() {
    VENV_LOCAL="$HOME/.dotfiles/.venv"
    REQS="$HOME/.dotfiles/config/requirements.txt"

    if [ ! -d "$VENV_LOCAL" ]; then
        python3 -m venv "$VENV_LOCAL"
    fi

    source "$VENV_LOCAL/bin/activate"

    pip install --upgrade pip
    pip install --upgrade -r "$REQS"
    pip freeze >"$REQS"

    deactivate
}

update_venvs() {
    venvs=("/opt/chomp/" "/opt/ansible/" "/opt/nomad/")
    for venv in "${venvs[@]}"; do
        cd "$venv" || exit

        echo -e "\n${GREEN}Backing up $venv ...${NC}"
        cp -r .venv .venv_bak
        cp -r requirements.txt ".requirements.txt.bak.$(date +'%Y-%m-%dT%H:%M:%S%z')"

        echo -e "\n${GREEN}Freezing $venv ...${NC}"
        pip freeze | cut -d '=' -f 1 | grep -v "@" >requirements.txt

        source "$venv/.venv/bin/activate"

        echo -e "\n${GREEN}Updating $venv ...${NC}"
        echo -e "\n${GREEN}Updating pip ...${NC}"
        pip install --upgrade pip
        echo -e "\n${GREEN}Upgrading pip packages ...${NC}"
        pip install --upgrade -r requirements.txt

        deactivate
        cd || exit
    done
}

update_zsh_plugins() {
    echo -e "\n${GREEN}Updating zsh plugins ...${NC}"
    zsh -c 'source ~/.zshrc && antidote'
}

update_llm_plugins() {
    for plugin in $(llm plugins | jq -M .[].name | tr -d '"'); do
        echo "Updating plugin: $plugin"
    done

}

print_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -b, --brew     Update brew packages"
    echo "  -v, --venvs    Update virtual environments"
    # echo "  -z, --zsh      Update zsh plugins"
    echo "  -l, --llm      Update LLM plugins"
    echo "  -a, --all      Update everything"
    echo "  -h, --help     Show this help message"
}

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
    -b | --brew) BREW=true ;;
    -p | --python) VENVS=true ;;
    # -z | --zsh) ZSH=true ;;
    -l | --llm) LLM=true ;;
    -a | --all) ALL=true ;;
    -h | --help)
        print_help
        exit 0
        ;;
    *)
        echo -e "\nUnknown parameter passed: $1"
        print_help
        exit 1
        ;;
    esac
    shift
done

# Execute sections based on flags
if [[ "$ALL" == true || "$BREW" == true ]]; then
    update_brew
fi

if [[ "$ALL" == true || "$VENVS" == true ]]; then
    update_local_pip
    # update_venvs
fi

if [[ "$ALL" == true || "$LLM" == true ]]; then
    update_llm_plugins
fi

# if [[ "$ALL" == true || "$ZSH" == true ]]; then
#     update_zsh_plugins
# fi
