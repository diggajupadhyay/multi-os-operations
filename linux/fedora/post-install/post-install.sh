#!/bin/bash

# dnf hacks
sudo bash -c 'cat << EOF >> /etc/dnf/dnf.conf
fastestmirror=True
max_parallel_downloads=10
defaultyes=True
EOF'

# Enable RPM Fusion repositories
sudo dnf install \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf group update core

# upgrade the system
sudo dnf --refresh upgrade -y

# Install plugins for playing movies and music
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf install lame\* --exclude=lame-devel
sudo dnf group upgrade --with-optional Multimedia

# install basic tools
sudo dnf install -y git vim tmux curl python3-pip htop asciinema flatpak

# add flathub repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# define the list of flatpak apps to install
flatpak_apps=("org.kde.kdenlive" "com.github.tchx84.Flatseal" "com.belmoussaoui.Obfuscate" "com.visualstudio.code" "com.bitwarden.desktop")

# loop through the list of apps
for app in "${flatpak_apps[@]}"
do
    # ask the user for confirmation
    read -p "Do you want to install $app? [y/n] " choice
    case "$choice" in 
        y|Y )
            # install the app if the user confirms
            flatpak install -y flathub "$app"
            ;;
        n|N )
            # do nothing and move on to the next app if the user declines
            echo "Skipping $app installation."
            ;;
        * )
            # handle invalid input and re-prompt for confirmation
            echo "Invalid input. Please enter y/n."
            ((i--))
            ;;
    esac
done

# install common software
read -p "Do you want to install Thunderbird? (y/n) " -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo dnf install -y thunderbird
fi

read -p "Do you want to install Nextcloud Desktop? (y/n) " -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo dnf install -y nextcloud-client
fi

read -p "Do you want to install GIMP? (y/n) " -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo dnf install -y gimp
fi

read -p "Do you want to install VLC? (y/n) " -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo dnf install -y vlc
fi

read -p "Do you want to install Steam? (y/n) " -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo dnf install -y steam
fi

# install development tools
#sudo dnf install -y podman podman-compose docker docker-compose

# install portmaster
wget -c --directory-prefix=/tmp/ https://updates.safing.io/latest/linux_amd64/packages/portmaster-installer.rpm
sudo dnf install -y /tmp/portmaster-installer.rpm

# configure git
read -p "Enter your full name: " full_name
read -p "Enter your email: " email
git config --global user.name "$full_name"
git config --global user.email "$email"

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
