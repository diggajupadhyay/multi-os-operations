#!/bin/bash

# update & upgrade the system
sudo apt-get update && sudo apt-get upgrade -y

# Install ubuntu-drivers-common to get the recommended NVIDIA driver
sudo apt update
sudo apt install -y ubuntu-drivers-common

# Check which NVIDIA driver is recommended for the system
recommended_driver=$(ubuntu-drivers devices | awk '/nvidia-driver/ {print $3}')

# Check which NVIDIA GPU is being used
gpu=$(lspci | grep -E "VGA|3D" | grep -i NVIDIA)

if [ -z "$gpu" ]; then
  echo "No NVIDIA GPU detected on this system."
fi

# Install the recommended NVIDIA driver
sudo ubuntu-drivers install -y "$recommended_driver"

echo "NVIDIA driver ($recommended_driver) has been successfully installed for the following GPU:"
echo "$gpu"

# install basic tools
sudo apt-get install -y git vim tmux curl python3-pip htop asciinema flatpak

# add flathub repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# install application from flathub
flatpak install -y flathub org.kde.kdenlive
flatpak install -y flathub com.github.tchx84.Flatseal
flatpak install -y flathub com.belmoussaoui.Obfuscate
flatpak install -y flathub com.visualstudio.code
flatpak install -y flathub com.bitwarden.desktop

# install multimedia codecs
sudo apt-get install -y ubuntu-restricted-extras

# install obs-studio
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt-get update
sudo apt-get install ffmpeg obs-studio

# install common software
sudo apt-get install thunderbird nextcloud-desktop gimp vlc steam

# install development tools
sudo apt-get install -y podman docker docker-compose && pip3 install --user podman-compose

# install portmaster
wget -c --directory-prefix=/tmp/ https://updates.safing.io/latest/linux_amd64/packages/portmaster-installer.deb
sudo apt-get install -y /tmp/portmaster-installer.deb

# configure git
read -p "Enter your full name: " full_name
read -p "Enter your email: " email
git config --global user.name "$full_name"
git config --global user.email "$email"

# clean up
sudo apt autoremove -y
sudo apt clean

# reboot
echo "It is recommended to reboot your system. Do it now? (y/n)"
read answer

if [ "$answer" = "y" ] || [ "$answer" = "Y" ] || [ "$answer" = "yes" ] || [ "$answer" = "Yes" ]; then
    echo "Rebooting in 5 seconds..."
    sleep 5
    sudo reboot
else
    echo "duhh! Don't break your system. Bye!"
fi
