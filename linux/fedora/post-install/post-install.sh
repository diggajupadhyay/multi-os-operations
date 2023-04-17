#!/bin/bash


# Notify user about checking for required lines in /etc/dnf/dnf.conf
echo "This script will check if the following lines exist in /etc/dnf/dnf.conf:"
echo "fastestmirror=True"
echo "max_parallel_downloads=10"
echo "defaultyes=True"

# Ask user if they want to proceed with checking for the lines
read -p "Do you want to proceed with checking? [Y/n] " response

# Convert response to uppercase for consistency
response=${response^^}
# Check if the user wants to proceed with checking
if [[ $response == "N" ]]; then
  echo "Skipping checking for lines in /etc/dnf/dnf.conf."
else
  # Check if the lines exist in /etc/dnf/dnf.conf
  if grep -Fxq "fastestmirror=True" /etc/dnf/dnf.conf && \
     grep -Fxq "max_parallel_downloads=10" /etc/dnf/dnf.conf && \
     grep -Fxq "defaultyes=True" /etc/dnf/dnf.conf; then
       echo "The lines already exist in the file."
  else
    # Append the three lines to the file if not already
    sudo tee -a /etc/dnf/dnf.conf >/dev/null <<EOF
    fastestmirror=True
    max_parallel_downloads=10
    defaultyes=True
EOF
    echo "The lines have been appended to the file."
  fi
fi



# Prompt user to enable RPM Fusion repositories
echo "This script will enable RPM Fusion free and non-free repositories."
read -p "Do you want to enable both free and non-free repositories? [Y/n] " response

# Convert response to uppercase for consistency
response=${response^^}
if [[ $response != "N" ]]; then
    # Enable RPM Fusion Free repositories if not already enabled
    if ! dnf list installed | grep -q 'rpmfusion-free-release'; then
        sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
    fi

    # Enable RPM Fusion NonFree repositories if not already enabled
    if ! dnf list installed | grep -q 'rpmfusion-nonfree-release'; then
        sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    fi

    echo "RPM Fusion free and non-free repositories have been enabled."

    # Ask the user if they want to update the core group
    read -p "Do you want to update the core group now? [Y/n] " response

    # Convert response to uppercase for consistency
    response=${response^^}
    if [[ $response != "N" ]]; then
        # Update the core group
        sudo dnf group update core
        echo "Group core updated successfully!"
    else
        echo "Skipping updating of the core group."
    fi
else
    echo "Skipping enabling of RPM Fusion repositories."
fi



# Define the required multimedia packages and the LAME library
multimedia_packages=("gstreamer1-plugins-bad-free" "gstreamer1-plugins-good" "gstreamer1-plugins-base" "gstreamer1-plugin-openh264" "gstreamer1-libav")
lame_library="lame"

# Check if required multimedia packages are already installed
if ! dnf list installed "${multimedia_packages[@]}" &> /dev/null; then
    # Prompt the user to install the multimedia packages
    read -p "You need to install some multimedia packages to play music and videos on your system. Do you want to install them now? [Y/n] " response
    response=${response^^}
    if [[ $response == "N" ]]; then
        echo "Skipping installation of multimedia packages."
    else
        sudo dnf install "${multimedia_packages[@]/#/gstreamer1-plugins-}" --exclude=gstreamer1-plugins-bad-free-devel
    fi
fi

# Check if LAME library is already installed
if ! dnf list installed "$lame_library" &> /dev/null; then
    # Prompt the user to install the LAME library
    read -p "You need to install LAME library to encode and decode MP3 files. Do you want to install it now? [Y/n] " response
    response=${response^^}
    if [[ $response == "N" ]]; then
        echo "Skipping installation of LAME library."
    else
        sudo dnf install "$lame_library"* --exclude=lame-devel
    fi

    # Prompt the user to update the multimedia group
    read -p "Do you want to update the multimedia group now? [Y/n] " response
    response=${response^^}
    if [[ $response == "N" ]]; then
        echo "Skipping updating of the multimedia group."
    else
        sudo dnf group update multimedia
        echo "Group multimedia updated successfully!"
    fi
fi



# Declare a variable with the list of basic tools to install
basic_tools=("git" "vim" "tmux" "curl" "python3-pip" "rust" "cargo" "htop" "asciinema" "flatpak")

# Loop through the list of tools
for tool in "${basic_tools[@]}"
do
    # Check if the tool is already installed
    if ! command -v "$tool" &> /dev/null
    then
        # Prompt the user to install the tool
        while true; do
            read -p "$tool is not installed. Do you want to install it? (y/n): " yn
            case $yn in
                [Yy]* )
                    sudo dnf install -y "$tool"
                    echo "$tool has been installed."
                    break
                    ;;
                [Nn]* )
                    echo "Skipping $tool installation."
                    break
                    ;;
                * )
                    echo "Please answer y or n."
                    ;;
            esac
        done
    else
        echo "$tool is already installed."
    fi
done



# Ask the user if they want to proceed with the upgrade
read -p "Do you want to upgrade your system now? [Y/n] " response

# Convert response to uppercase for consistency
response=${response^^}
if [[ $response == "N" ]]; then
    echo "Skipping system upgrade."
else
    # Perform the system upgrade
    echo "Upgrading system..."
    sudo dnf --refresh upgrade
    echo "System upgrade complete!"
fi



# Check if Flathub is already enabled
if flatpak remotes | grep -q "flathub"; then
    echo "Flathub is already enabled."
else
    # Ask the user if they want to enable Flathub
    read -p "Flathub is not enabled. Do you want to enable it now? [Y/n] " response

    # Convert response to uppercase for consistency
    response=${response^^}

    if [[ $response == "N" ]]; then
        echo "Skipping enabling of Flathub."
    else
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        echo "Flathub has been enabled."
    fi
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



# Check if Portmaster is already installed
if [ -d "/opt/portmaster" ]; then
    echo "Portmaster is already installed."
else
    # Ask the user if they want to install Portmaster
    read -p "Portmaster is not installed. Do you want to install it now? [Y/n] " response

    # Convert response to uppercase for consistency
    response=${response^^}
    if [[ $response == "N" ]]; then
        echo "Skipping installation of Portmaster."
    else
        # Download and install Portmaster
        echo "Downloading Portmaster installer..."
        wget -c --directory-prefix=/tmp/ https://updates.safing.io/latest/linux_amd64/packages/portmaster-installer.rpm
        echo "Installing Portmaster..."
        sudo dnf install -y /tmp/portmaster-installer.rpm
        echo "Portmaster installed successfully!"
    fi
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


# Check if firewalld is installed
if ! command -v firewall-cmd &> /dev/null
then
    # Install firewalld if it is not installed
    sudo dnf install -y firewalld
fi

# Enable and start the firewall
sudo systemctl enable firewalld
sudo systemctl start firewalld

# Block default services and ports except for SSH
sudo firewall-cmd --zone=public --add-service=ssh --permanent
sudo firewall-cmd --zone=public --remove-service=dhcpv6-client --permanent
sudo firewall-cmd --zone=public --remove-service=mdns --permanent
sudo firewall-cmd --zone=public --remove-service=samba-client --permanent
sudo firewall-cmd --zone=public --remove-service=samba --permanent
sudo firewall-cmd --zone=public --remove-service=dhcpv6 --permanent
sudo firewall-cmd --reload


# configure git
read -p "Do you want to configure git? (y/n) " -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    read -r -p "Enter your full name: " full_name
    read -r -p "Enter your email: " email
    git config --global user.name "$full_name"
    git config --global user.email "$email"
else
    echo "Skipping git configuration."
fi


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
