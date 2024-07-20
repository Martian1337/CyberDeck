# CyberDeck

## Description

CyberDeck is a script designed for setting up a web pentesting environment. It installs a wide range of essential tools for network reconnaissance, vulnerability analysis, exploitation, and is specifically tailored to web security testing.

## Features

- **Compatibility:** Works with both Debian-based systems and Arch Linux.
- **Bug Bounty Toolset:** Installs a variety of tools covering different aspects of cybersecurity, including reconnaissance, scanning, exploitation, and more.
- **Automated Installation:** Streamlines the setup process, saving time and reducing manual effort.

## Prerequisites

- Linux-based system (Debian-based or Arch Linux)
- Stable Internet connection
- Sufficient user permissions (root or sudo access)

## Installation

1. Clone the repository and run script:
   ```bash
   sudo apt install git -y && git clone https://github.com/Martian1337/CyberDeck.git && cd CyberDeck && chmod +x install.sh && ./install.sh && rm -rf install.sh

**OR**

2. Run script directly via CURL:
```bash
sudo apt install curl -y && curl -o install.sh -L https://raw.githubusercontent.com/Martian1337/CyberDeck/main/install.sh && chmod +x install.sh && ./install.sh && rm -rf install.sh
```

**OR**

3. Run script with WGET:
```bash
sudo apt install wget -y && wget https://raw.githubusercontent.com/Martian1337/CyberDeck/main/install.sh -O install.sh && chmod +x install.sh && ./install.sh && rm -rf install.sh
```

## Tool List

Here's a non-exhaustive list of the tools included in this installer:

- **Reconnaissance Tools:** `Amass`, `Masscan`, `Massdns`, `ReconFTW`
- **Scanning Tools:** `Nmap`, `RustScan`
- **Web Application Analysis:** `WhatWeb`, `Wappalyzer`
- **Content Discovery:** `Gobuster`, `Dirsearch`, `Feroxbuster`
- **Exploitation Tools:** `SQLmap`, `Commix`
- And more...
