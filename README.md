# Dotfiles

This repository contains configuration files and setup scripts used to provision development environments on Linux and macOS.

## Directory overview

- **ai** – Tools and configuration for interacting with large language models.  Includes helper scripts and Aider configuration.
- **bash** – Bash configuration, helper functions and aliases.
- **config** – Miscellaneous configuration such as requirements and terminfo files.
- **init** – Platform specific installation scripts used by `init.sh`.
- **iterm** – iTerm2 preferences.
- **nvim** – Neovim configuration and plugins.
- **scripts** – Various helper scripts for day to day tasks.
- **setup** – Ansible playbook and roles for bootstrapping a new workstation.
- **tmux** – Tmux configuration files.

## Getting started

Clone the repository into `~/.dotfiles` and run the main setup script. The script can install packages and link configuration files into your home directory.

```bash
cd ~/.dotfiles
./init.sh [options]
```

Available options:

- `-i, --install` – install prerequisite packages using the appropriate platform script in `init/`.
- `-l, --link` – create symlinks from your home directory to the files in this repository.
- `-m, --llm` – install the `llm` tool, `aider`, and related plugins using `uv`.
- `-o, --op` – configure secrets via the 1Password CLI.

Run the script with the options that match your environment. After linking the configuration open a new shell so the settings take effect.

## Notes

Many scripts expect the [uv](https://github.com/astral-sh/uv) package manager for Python and other development tools to be available.
