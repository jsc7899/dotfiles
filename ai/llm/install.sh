#!/usr/bin/env bash
set -euo pipefail

# install llm and plugins
# https://llm.datasette.io/en/stable/setup.html

if ! command -v uv >/dev/null 2>&1; then
    echo "uv not found. installing via brew..."
    brew install uv
fi

if ! command -v llm >/dev/null 2>&1; then
    echo "installing llm via uv..."
    uv tool install llm
else
    echo "uv is installed"
fi

# plugins
echo "installing llm plugins..."
desired_plugins=(
    "llm-jq"       # https://github.com/simonw/llm-jq
    "llm-cmd-comp" # https://github.com/CGamesPlay/llm-cmd-comp
    "llm-cmd"      # https://github.com/simonw/llm-cmd
)

# map string of plugins to array
mapfile -t installed_plugins < <(llm plugins | jq -r '.[].name')

for plugin in "${desired_plugins[@]}"; do
    if [[ " ${installed_plugins[*]} " =~ " $plugin " ]]; then
        echo "$plugin is already installed."
    else
        echo "Installing $plugin..."
        llm install "$plugin"
    fi
done
