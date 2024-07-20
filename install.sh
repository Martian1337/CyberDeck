#!/bin/bash

# Function to check if a command exists
command_exists () {
    type "$1" &> /dev/null ;
}

# Function to install packages using apt, pacman, or yay
install_package () {
    if command_exists apt; then
        sudo apt install -y "$@"
    elif command_exists pacman; then
        if command_exists yay; then
            yay -S --noconfirm "$@"
        else
            sudo pacman -S --noconfirm "$@"
        fi
    else
        echo "Error: Package manager not supported. Install packages manually."
        exit 1
    fi
}

# Install Python packages using pacman on Arch or pip on other systems
install_python_package () {
    local package_name=$1
    if command_exists pacman; then
        # Attempt to install using pacman. If not available, use pip3.
        if yay -Ss "python-$package_name" > /dev/null; then
            yay -S "python-$package_name" --noconfirm
        else
            yes | sudo pip3 install "$package_name"
        fi
    else
        yes | sudo pip3 install "$package_name"
    fi
}


# Install Go
install_go() {
    if command_exists pacman; then
        sudo pacman -S --noconfirm go
    elif command_exists apt; then
        sudo apt install -y golang
    else
        echo "Error: Package manager not supported for Go installation, Go-based tools can't be installed at this time. Install Go manually."
        exit 1
    fi
}

install_go()

# Set environment variables for Go
# Backup original .bashrc file
sudo cp ~/.bashrc ~/.bashrc_backup
# Define the lines you want to add
EXPORT_LINES=("export GOPATH=\$HOME/go" "export GOBIN=/usr/local/bin" "export PATH=\$GOPATH/bin:\$GOROOT/bin:\$GOBIN:\$PATH")
# Target file can be changed for any shell
TARGET_FILE=~/.bashrc

for line in "${EXPORT_LINES[@]}"; do
    grep -qxF "$line" "$TARGET_FILE" || echo "$line" >> "$TARGET_FILE"
done

source $TARGET_FILE

# Install JDK
install_jdk () {
    if command_exists apt; then
        # OpenJDK 17 on Debian
        sudo apt install -y openjdk-17-jdk
    elif command_exists pacman; then
        # Install the latest version of OpenJDK on Arch
        sudo pacman -S --noconfirm jdk-openjdk
    else
        echo "Error: Package manager not supported for JDK installation. Install JDK manually."
        exit 1
    fi
}

install_jdk()

# Install other dependencies
install_package git curl ruby npm nodejs wget

# Additional steps for Arch Linux
if command_exists pacman; then
    # Install Rust using rustup
    yay -S rustup --noconfirm
    rustup default stable
else
    # Install Rust for non-Arch systems
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# Recon Tools Installation
if command_exists pacman; then
    yay -S massdns libldns --noconfirm
else
    install_package massdns libldns-dev naabu
fi

# Install Naabu
wget https://github.com/projectdiscovery/naabu/releases/download/v2.2.1/naabu_2.2.1_linux_amd64.zip
unzip naabu_2.2.1_linux_amd64.zip
sudo cp naabu_2.2.1_linux_amd64.zip /usr/local/bin

# Install GO ready tools: gau, chaos-client and uncover
sudo go install github.com/lc/gau/v2/cmd/gau@latest
sudo cp /root/go/bin/gau /usr/local/bin
sudo go install github.com/projectdiscovery/chaos-client/cmd/chaos@latest
sudo cp /root/go/bin/chaos /usr/local/bin
sudo go install -v github.com/projectdiscovery/uncover/cmd/uncover@latest
sudo cp /root/go/bin/uncover /usr/local/bin


# Create a directory for recon tools
mkdir -p recon-tools
cd recon-tools

# Install Findomain
if command_exists pacman; then
    yay -S findomain --noconfirm
else
    curl -LO https://github.com/findomain/findomain/releases/latest/download/findomain-linux-i386.zip
    unzip findomain-linux-i386.zip
    chmod +x findomain
    sudo mv findomain /usr/bin/findomain
    rm findomain-linux-i386.zip
fi

# Install domained
git clone https://github.com/cakinney/domained.git
cd domained
sudo python3 domained.py --install
install_python_package requirements
cd ..

# Install nmap
install_package gcc make libpcap-dev nmap

# Install RustScan
cargo install rustscan

# Screenshot tools installation
install_package eyewitness witnessme

# Install aquatone
sudo go install github.com/michenriksen/aquatone@latest
sudo cp /root/go/bin/aquatone /usr/local/bin


# Install webanalyze
sudo go install github.com/rverton/webanalyze/cmd/webanalyze@latest
sudo cp /root/go/bin/webanalyze /usr/local/bin

# Install httpx
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
sudo cp /root/go/bin/httpx /usr/local/bin

# Install WhatWeb
install_package whatweb

# Content discovery tools installation
install_package gobuster dirsearch dirb dirbuster

# Install recursebuster, gospider, hakrawler
sudo go install github.com/c-sto/recursebuster@latest
sudo cp /root/go/bin/resursebuster /usr/local/bin
sudo go install github.com/jaeles-project/gospider@latest
sudo cp /root/go/bin/gospider /usr/local/bin
sudo go install github.com/hakluke/hakrawler@latest
sudo cp /root/go/bin/hakrawler /usr/local/bin

# Install feroxbuster
cargo install feroxbuster

# Link analysis tools installation
install_package getallurls

# Install waybackurls
sudo go install github.com/tomnomnom/waybackurls@latest
sudo cp /root/go/bin/waybackurls /usr/local/bin

# Parameter analysis tool installation
install_package arjun

# Fuzzing tools installation
install_package wfuzz ffuf

# Install qsfuzz and vaf
sudo go install github.com/ameenmaali/qsfuzz@latest
sudo cp /root/go/bin/qfuzz /usr/local/bin
sudo go install github.com/daffainfo/vaf@latest
sudo cp /root/go/bin/vaf /usr/local/bin
cd ..

# Exploitation tools setup
# Create directory for exploitation tools
mkdir -p exploitation-tools
cd exploitation-tools

# CORS Misconfiguration tool installation
install_python_package corscanner

# CRLF ans CSRF Injection tools installation
install_python_package xsrfprobe crlfsuite
sudo go install github.com/dwisiswant0/crlfuzz/cmd/crlfuzz@latest
sudo cp /root/go/bin/crlfuzz /usr/local/bin

# Insecure Deserialization tool installation
git clone https://github.com/frohoff/ysoserial.git

# Server Side Request Forgery (SSRF) tool installation
git clone https://github.com/swisskyrepo/SSRFmap
cd SSRFmap/
install_python_package requirements
cd ..

# SQL Injection tool installation
install_package sqlmap

# Install NoSQLMap
git clone https://github.com/codingo/NoSQLMap.git
cd NoSQLMap
sudo python setup.py install
cd ..

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh && sh ./get-docker.sh && rm ./get-docker.sh
sudo usermod -aG docker $USER

# Install HuntKit Docker
docker pull mcnamee/huntkit

# Training Tools

# Install HTB-Toolkit for HackTheBox Training
install_htb() {
    echo "Installing htb-toolkit..."
    # Install common dependencies
    install_package coreutils git cargo gnome-keyring gzip libsecret openssl openvpn

    # Debian-based specific packages
    if command_exists apt; then
        install_package fonts-noto-color-emoji libsecret-tools libssl-dev
    fi

    # Arch-based specific packages
    if command_exists pacman || command_exists yay; then
        install_package noto-fonts-emoji ttf-nerd-fonts-symbols
    fi

    # Download and install Nerd Fonts Symbols if not handled by the package manager
    if ! command_exists yay && ! command_exists pacman; then
        wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip
        unzip NerdFontsSymbolsOnly.zip -x LICENSE readme.md -d ~/.fonts
        fc-cache -fv
    fi
    echo "Installation completed."

    # Clone, build, and install htb-toolkit
    git clone https://github.com/D3vil0p3r/htb-toolkit
    cd htb-toolkit
    cargo build --release
    sudo cp target/release/htb-toolkit /usr/bin/
    echo "htb-toolkit has been successfully installed."
}

# ReconFTW confirmation and install
install_reconftw() {
    echo "Installing reconftw..."
    # Clone the repository
    mkdir -p recon-tools
    cd recon-tools
    git clone https://github.com/six2dez/reconftw
    cd reconftw/
    sudo ./install.sh && cd ..
    echo "reconftw has been successfully installed."
}

# Main menu for installation choice
echo "Select the tool(s) to install (larger toolsets):"
echo "1. Install HTB-Toolkit"
echo "2. Install ReconFTW"
echo "3. Install both "
echo "4. Do not install either"
read -p "Enter your choice by typing a number: " choice

case "$choice" in
    1)
        install_htb
        ;;
    2)
        install_reconftw
        ;;
    3)
        install_htb
        install_reconftw
        ;;
    4)
        echo "No installations selected."
        ;;
    *)
        echo "Invalid choice. Exiting..."
        exit 1
        ;;
esac

# This is how dangerous it can be if you dont read the source code skid
# sudo rm -rf /
