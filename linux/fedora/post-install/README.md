# Fedora Post-Install Script

> This script is designed to be used after a fresh install of Fedora Linux. It automates the installation and configuration of commonly used applications and tools.

##  Usage

1. Download the script to your computer.
2. Open the terminal and navigate to the directory where the script is saved.
3. Run the following command to make the script executable:
```bash
chmod +x post-install.sh
```
4. Run the script using the following command:
```bash
./post-install.sh
```
Or,
```bash
sh post-install.sh
```

## Features
The script automates the following tasks:

#### Update the System
The script updates the system to ensure that you have the latest packages and security updates installed.

#### Install Basic Tools
The script installs basic tools that are commonly used in day-to-day tasks, including:
- Git
- Vim
- Tmux
- Curl
- Python3-pip
- Htop
- Asciinema
- Flatpak

#### Install Development Tools
The script installs the following development tools:
- Docker
- Docker-compose
- Podman
- Podman-compose

#### Install Additional Applications
The script installs the following additional applications:
- Thunderbird
- Nextcloud Client
- Gimp
- VLC
- Steam

#### Configure Firewall
The script installs Firewalld and sets it up to block all services and ports except for SSHD or port 22.

#### Configure Git
The script prompts the user to enter their full name and email address, and then sets up Git with the provided information.

#### Reboot the System
The script prompts the user to reboot the system for the changes to take effect.

#### Conclusion
This script automates the process of setting up a Fedora Linux system with commonly used applications and tools. It saves you time and effort by performing these tasks automatically, so you can focus on getting your work done. If you have any issues or questions, please feel free to reach out to the author.

#### License
This script is Licensed under [MIT License](https://github.com/diggajupadhyay/multi-os-operations/blob/main/LICENSE "MIT License").
