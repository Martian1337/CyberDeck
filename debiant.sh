#!/bin/bash

# Function to check if a command exists
command_exists () {
    type "$1" &> /dev/null ;
}

# Function to install Python packages using pip3
install_python_package () {
    local package_name=$1
    sudo pip3 install "$package_name" --yes
}

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

# Install dependencies
sudo apt update --fix-missing
sudo apt install golang git curl ruby npm nodejs wget openjdk-17-jdk libpcap-dev python3-pip pipx gcc make -y
sudo pipx ensurepath

# Install Rust for Debian-based systems
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y


# Recon Tools Installation
sudo apt install massdns libldns-dev -y

# Install Naabu
wget https://github.com/projectdiscovery/naabu/releases/download/v2.2.1/naabu_2.2.1_linux_amd64.zip
unzip naabu_2.2.1_linux_amd64.zip
sudo cp naabu /usr/local/bin

# Install GO ready recon tools tools: gau, chaos-client and uncover
sudo go install github.com/lc/gau/v2/cmd/gau@latest
sudo cp "$GOPATH/bin/gau" /usr/local/bin
sudo go install github.com/projectdiscovery/chaos-client/cmd/chaos@latest
sudo cp "$GOPATH/bin/chaos" /usr/local/bin
sudo go install -v github.com/projectdiscovery/uncover/cmd/uncover@latest
sudo cp "$GOPATH/bin/uncover" /usr/local/bin

# Install bbot and crosslinked
pipx install bbot
pip3 install crosslinked

# Install Cracking tools
sudo apt install hashcat john hydra-gtk -y

# Create a directory for recon tools
mkdir -p recon-tools
cd recon-tools

# Install Findomain
curl -LO https://github.com/findomain/findomain/releases/latest/download/findomain-linux-i386.zip
unzip findomain-linux-i386.zip
chmod +x findomain
sudo mv findomain /usr/bin/findomain
rm findomain-linux-i386.zip
cd ..

# Install domained
git clone https://github.com/cakinney/domained.git
cd domained
sudo python3 domained.py --install
install_python_package -r requirements.txt
cd ..

# Install RepoReaper
git clone https://github.com/YourUsername/RepoReaper.git
cd RepoReaper
pip install -r requirements.txt
chmod +x RepoReaper.py
cd ..

# Install nmap
sudo apt install nmap -y

# Install RustScan
cargo install rustscan

# Screenshot tools installation
sudo apt install eyewitness witnessme -y

# Install aquatone
sudo go install github.com/michenriksen/aquatone@latest
sudo cp "$GOPATH/bin/aquatone" /usr/local/bin

# Install webanalyze
sudo go install github.com/rverton/webanalyze/cmd/webanalyze@latest
sudo cp "$GOPATH/bin/webanalyze" /usr/local/bin

# Install httpx
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
sudo cp "$GOPATH/bin/httpx" /usr/local/bin

# Content discovery tools installation
sudo apt install whatweb gobuster dirsearch dirb dirbuster -y

# Install recursebuster, gospider, hakrawler
sudo go install github.com/c-sto/recursebuster@latest
sudo cp "$GOPATH/bin/recursebuster" /usr/local/bin
sudo go install github.com/jaeles-project/gospider@latest
sudo cp "$GOPATH/bin/gospider" /usr/local/bin
sudo go install github.com/hakluke/hakrawler@latest
sudo cp "$GOPATH/bin/hakrawler" /usr/local/bin

# Install feroxbuster
cargo install feroxbuster

# Install waybackurls
sudo go install github.com/tomnomnom/waybackurls@latest
sudo cp "$GOPATH/bin/waybackurls" /usr/local/bin

# Parameter analysis tool installation
sudo apt install arjun -y

# Fuzzing tools installation
sudo apt install wfuzz ffuf -y

# Install qsfuzz and vaf
sudo go install github.com/ameenmaali/qsfuzz@latest
sudo cp "$GOPATH/bin/qsfuzz" /usr/local/bin
sudo go install github.com/daffainfo/vaf@latest
sudo cp "$GOPATH/bin/vaf" /usr/local/bin
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
sudo cp "$GOPATH/bin/crlfuzz" /usr/local/bin

# Insecure Deserialization tool installation
git clone https://github.com/frohoff/ysoserial.git

# Server Side Request Forgery (SSRF) tool installation
git clone https://github.com/swisskyrepo/SSRFmap
cd SSRFmap/
install_python_package -r requirements.txt
cd ..

# SQL Injection tool installation
sudo apt install sqlmap

# Install NoSQLMap
git clone https://github.com/codingo/NoSQLMap.git
cd NoSQLMap
sudo python setup.py install
cd ..

# Fluxion install
git clone https://www.github.com/FluxionNetwork/fluxion.git
cd fluxion
sudo ./fluxion.sh -i
cd ..


# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh && sh ./get-docker.sh && rm ./get-docker.sh
sudo usermod -aG docker $USER

# Install HTB-Toolkit for HackTheBox Training
install_htb() {
    echo "Installing htb-toolkit..."
    # Install common dependencies
    sudo apt install coreutils git cargo gnome-keyring gzip libsecret openssl openvpn -y

    # Debian-based specific packages
    sudo apt install fonts-noto-color-emoji libsecret-tools libssl-dev -y

    # Download and install Nerd Fonts Symbols if not handled by the package manager
    wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip
    unzip NerdFontsSymbolsOnly.zip -x LICENSE readme.md -d ~/.fonts
    fc-cache -fv

    echo "Installation completed."

    # Clone, build, and install htb-toolkit
    git clone https://github.com/D3vil0p3r/htb-toolkit
    cd htb-toolkit
    cargo build --release
    sudo cp target/release/htb-toolkit /usr/bin/
    echo "htb-toolkit has been successfully installed."
}

# Install HuntKit Docker
install_hunkit () {
    docker pull mcnamee/huntkit
}

# ReconFTW confirmation and install
install_reconftw() {
    echo "Installing reconftw..."
    # Clone the repository
    git clone https://github.com/six2dez/reconftw
    cd reconftw/
    sudo ./install.sh && cd ..
    echo "reconftw has been successfully installed."
}


install_vulnscanners() {
    echo "Installing Wapiti, OpenVAS and Sirius"
    pip install wapiti3
    git clone https://github.com/SiriusScan/Sirius.git
    cd Sirius
    docker-compose up
    sudo apt install openvas
    echo "Vulnerability Scanners installed. Ensure to refer to tool documentation for setup!"
}


install_ad_tools() {
    echo "Setting up Active Directory tools..."
    install_empire
    install_teamfiltration
    install_impacket
    install_bloodhound
    install_metasploit
    install_trevorspray
    sudo apt install evil-winrm -y
    echo "Active Directory tools setup complete."
}

# Install Powershell Empire
install_empire() {
    git clone --recursive https://github.com/BC-SECURITY/Empire.git
    cd Empire || exit 1  # Change directory to Empire; exit if fails
    ./setup/checkout-latest-tag.sh || exit 1
    ./ps-empire install -y || exit 1
}

# Install Teamfiltration
install_teamfiltration() {
    cd ..
    wget https://github.com/Flangvik/TeamFiltration/releases/download/v3.5.4/TeamFiltration-v3.5.4-linux-x86_64.zip
    unzip TeamFiltration-v3.5.4-linux-x86_64.zip
    sudo cp TeamFiltration /usr/local/bin
}

# Install Impacket
install_impacket() {
    python3 -m pipx install impacket
}

# Install Bloodhound
install_bloodhound() {
    curl -L https://ghst.ly/getbhce | docker compose -f - up
}

# Install Responder
install_responder() {
    git clone https://github.com/lgandx/Responder.git
}

# Install Metasploit
install_metasploit() {
    curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall
}   

# Install Trevorspray
install_trevorspray() {
pip install git+https://github.com/blacklanternsecurity/trevorproxy
pip install git+https://github.com/blacklanternsecurity/trevorspray
}

# Main menu for installation choice
echo "Select the tool(s) to install (larger toolsets):"
echo "1. Install HTB-Toolkit"
echo "2. Install HuntKit Docker"
echo "3. Install ReconFTW"
echo "4. Install Vulnerability scanners"
echo "5. Install Active Directory tools"
echo "6. Install All"
echo "7. Do not install additional tools"
read -p "Enter your choices separated by spaces (e.g., '1 2 3') or '5' to skip: " choices


# User choices
IFS=' ' read -ra choices <<< "$choices"

for choice in "${choices[@]}"; do
    case "$choice" in
        1)
            install_htb
            ;;
        2)
            install_huntkit
            ;;
        3)
            install_reconftw
            ;;
        4)
            install_vulnscanners
            ;;
        5)
            install_ad_tools
            ;;
        6)
            install_htb
            install_huntkit
            install_reconftw
            install_vulnscanners
            install_ad_tools
            ;;
        7)
            echo "No installations selected."
            ;;
        *)
            echo "Invalid choice: $choice. Skipping..."
            continue
            ;;
    esac

    # Give user option to install more
    read -p "Do you want to install another tool? (yes/no): " answer
    case "$answer" in
        [Yy]|[Yy][Ee][Ss])
            continue
            ;;
        *)
            break
            ;;
    esac
done

echo "Installation complete."

# This is how dangerous it can be if you dont read the source code skid
# sudo rm -rf /
