#!/bin/bash
set -e

# Timestamp
TS=$(date +%F_%H%M)

# Backup directory
BACKUP_DIR=/var/backups/myapp
SRC=/srv/myapp

# Create backup directory if it doesn't exist
sudo mkdir -p "$BACKUP_DIR"

# Create a compressed backup
sudo tar -czf "${BACKUP_DIR}/myapp_${TS}.tar.gz" -C /srv myapp

# Keep only the
