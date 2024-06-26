#!/bin/bash

install_macos() {
    echo "Installing prerequisites for macOS..."
    xcode-select --install

    echo "Installing Python and Ansible..."
    brew install python ansible
}

install_debian() {
    echo "Installing prerequisites for Debian-based systems..."
    sudo apt update
    sudo apt install -y ansible
}

install_redhat() {
    echo "Installing prerequisites for Red Hat-based systems..."
    sudo yum install -y epel-release
    sudo yum install -y ansible
}

if [[ "$OSTYPE" == "darwin"* ]]; then
    install_macos
elif [[ -f /etc/debian_version ]]; then
    install_debian
elif [[ -f /etc/redhat-release ]]; then
    install_redhat
else
    echo "Unsupported operating system."
    exit 1
fi

# cd $HOME/.workstations/setup/

echo -e "Running Ansible playbook...\n"
ansible-playbook install.yaml -K
