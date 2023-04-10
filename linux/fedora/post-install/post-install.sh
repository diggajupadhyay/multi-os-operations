#!/bin/bash

# set variables
dnf_config=/etc/dnf/dnf.conf
rpmfusion_free_url=https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
rpmfusion_nonfree_url=https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
basic_tools=(git vim tmux curl python3-pip tree htop tlp tlp-rdw powertop asciinema flatpak gnome-tweaks gnome-extensions-app)
common_software=(thunderbird gimp nextcloud-client vlc steam portmaster)
development_tools=(docker docker-compose podman podman-compose)
flatpak_remote=https://flathub.org/repo/flathub.flatpakrepo
flatpak_apps=(org.kde.kdenlive com.github.tchx84.Flatseal com.belmoussaoui.Obfuscate com.visualstudio.code com.bitwarden.desktop)

add_dnf_hacks() {
  echo -e "fastestmirror=True\nmax_parallel_downloads=10\ndefaultyes=True" | sudo tee -a "$dnf_config" > /dev/null
}

install_rpmfusion_repos() {
  sudo dnf install -y "$rpmfusion_free_url" "$rpmfusion_nonfree_url"
  sudo dnf group update core
}

upgrade_system() {
  sudo dnf --refresh upgrade -y
}

install_multimedia_plugins() {
  sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
  sudo dnf install -y lame\* --exclude=lame-devel
  sudo dnf group upgrade --with-optional Multimedia
}

install_basic_tools() {
  for app in "${basic_tools[@]}"
  do
    read -r -p "Do you want to install $app? [y/n] " choice
    if [[ "$choice" =~ [yY] ]]; then
      sudo dnf install -y "$app"
    else
      echo "Skipping $app installation."
    fi
  done
}

add_flathub_repo() {
  flatpak remote-add --if-not-exists flathub "$flatpak_remote"
}

install_flatpak_apps() {
  for app in "${flatpak_apps[@]}"
  do
    read -r -p "Do you want to install $app? [y/n] " choice
    if [[ "$choice" =~ [yY] ]]; then
      flatpak install -y "$flatpak_remote" "$app"
    else
      echo "Skipping $app installation."
    fi
  done
}

install_common_software() {
  for app in "${common_software[@]}"
  do
    read -r -p "Do you want to install $app? [y/n] " choice
    if [[ "$choice" =~ [yY] ]]; then
      sudo dnf install -y "$app"
    else
      echo "Skipping $app installation."
    fi
  done
}

install_development_tools() {
  for app in "${development_tools[@]}"
  do
    read -r -p "Do you want to install $app? [y/n] " choice
    if [[ "$choice" =~ [yY] ]]; then
      sudo dnf install -y "$app"
    else
      echo "Skipping $app installation."
    fi
  done
}

# configure git
read -r -p "Enter your full name: " full_name
read -r -p "Enter your email: " email
git config --global user.name "$full_name"
git config --global user.email "$email"

read -p "It is recommended to reboot your system. Do it now? (y/n)" answer

if [[ $answer =~ ^[Yy][EeSs]?$ ]]; then
  echo "Rebooting in 5 seconds..."
  sleep 5
  sudo reboot
else
  echo "Okay, but don't forget to reboot later if needed. Bye!"
fi

