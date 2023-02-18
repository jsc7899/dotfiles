#!/bin/sh

# install pip
python3 -m ensurepip --upgrade
python3 -m pip install --upgrade pip

# install ansible
pip3 install ansible

# install ansible community
ansible-galaxy collection install community.general

# run init playbook
ansible-playbook -i hosts.ini init.yaml