#!/bin/bash


# check for these lines in /etc/dnf/dnf.conf
if grep -Fxq "fastestmirror=True" /etc/dnf/dnf.conf && \
   grep -Fxq "max_parallel_downloads=10" /etc/dnf/dnf.conf && \
   grep -Fxq "defaultyes=True" /etc/dnf/dnf.conf; then
   echo "The lines already exist in the file."
else
  # append the three lines to the file if not already
  sudo tee -a /etc/dnf/dnf.conf >/dev/null <<EOF
  fastestmirror=True
  max_parallel_downloads=10
  defaultyes=True
EOF
    echo "The lines have been appended to the file."
fi


# Enable RPM Fusion repositories if not already enabled
if ! dnf list installed | grep -q 'rpmfusion-free-release'; then
  sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
fi

if ! dnf list installed | grep -q 'rpmfusion-nonfree-release'; then
  sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
fi

sudo dnf group update core


# Check if required multimedia packages are already installed
if ! dnf list installed | grep -q gstreamer1-plugins-bad-free; then
    # Install plugins for playing movies and music
    sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
fi

if ! dnf list installed | grep -q lame; then
    sudo dnf install lame\* --exclude=lame-devel
fi

# Upgrade multimedia packages
sudo dnf group upgrade --with-optional Multimedia


# upgrade the system
sudo dnf --refresh upgrade -y


# Check if flathub already enabled
if ! flatpak remotes | grep -q "flathub"; then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# define the list of flatpak apps to install
flatpak_apps=("org.kde.kdenlive" "com.github.tchx84.Flatseal" "com.belmoussaoui.Obfuscate" "com.visualstudio.code" "com.bitwarden.desktop")

# loop through the list of apps
for app in "${flatpak_apps[@]}"
do
    # check if the app is already installed
    if flatpak list | grep -q "$app"; then
        echo "$app is already installed."
    else
        # ask the user for confirmation if the app is not installed
        read -r -p "Do you want to install $app? [y/n] " choice
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
    fi
done


# Define the list of software to install
software=("Thunderbird" "Nextcloud Desktop" "GIMP" "VLC" "Steam")

# Define the corresponding package names
packages=("thunderbird" "nextcloud-client" "gimp" "vlc" "steam")

# Loop through the list of software
for i in "${!software[@]}"
do
    # Ask the user for confirmation
    read -r -p "Do you want to install ${software[$i]}? [y/n] " choice
    case "$choice" in 
        y|Y )
            # Install the package if the user confirms
            sudo dnf install -y "${packages[$i]}"
            ;;
        n|N )
            # Do nothing and move on to the next package if the user declines
            echo "Skipping ${software[$i]} installation."
            ;;
        * )
            # Handle invalid input and re-prompt for confirmation
            echo "Invalid input. Please enter y/n."
            ((i--))
            ;;
    esac
done


# Check if portmaster is already installed
if [ -d "/opt/portmaster" ]; then
    echo "Portmaster is already installed."
else
    wget -c --directory-prefix=/tmp/ https://updates.safing.io/latest/linux_amd64/packages/portmaster-installer.rpm
    sudo dnf install -y /tmp/portmaster-installer.rpm
fi


# Define the list of development tools to install
development_tools=("podman" "podman-compose" "docker" "docker-compose")

# Loop through the list of development tools
for tool in "${development_tools[@]}"
do
    # Check if the tool is installed
    if ! command -v "$tool" &> /dev/null
    then
        # Ask the user for confirmation
        read -p "Do you want to install $tool? (y/n) " -r
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            # Install the tool if the user confirms
            sudo dnf install -y "$tool"
        fi
    else
        echo "$tool is already installed."
    fi
done


# configure git
read -r -p "Enter your full name: " full_name
read -r -p "Enter your email: " email
git config --global user.name "$full_name"
git config --global user.email "$email"


# prompt the user to reboot
read -r -p "It is recommended to reboot your system. Do you want to reboot now? [y/n] " choice
case "$choice" in 
    y|Y )
        echo "Rebooting in 5 seconds..."
        sleep 5
        sudo reboot
        ;;
    n|N )
        echo "Okay, you can manually reboot later if needed."
        ;;
    * )
        echo "Invalid input. Please enter y/n."
        ;;
esac

