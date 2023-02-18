#!/bin/bash

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install pip
python -m ensurepip --upgrade

# install ansible
pip install ansible 

# install ansible community
ansible-galaxy collection install community.general

