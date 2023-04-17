#!/bin/bash

# Check if the backup directory exists, if not create it
if [ ! -d /srv/backup ]; then
  sudo mkdir -p /srv/backup
fi

# Get current date and time for directory name
BACKUP_DIR_NAME=$(date +'%Y-%m-%d_%H-%M-%S')
BACKUP_DIR="/srv/backup/$BACKUP_DIR_NAME"

# Create backup directory
sudo mkdir "$BACKUP_DIR"

# Backup Firefox profiles
if [ -d "$HOME/.mozilla" ]; then
  sudo tar -czvf "$BACKUP_DIR/mozilla.tar.gz" -C "$HOME" .mozilla/
fi

# Backup Thunderbird profiles
if [ -d "$HOME/.thunderbird" ]; then
  sudo tar -czvf "$BACKUP_DIR/thunderbird.tar.gz" -C "$HOME" .thunderbird/
fi

echo "Backed up Firefox and Thunderbird profiles to $BACKUP_DIR"