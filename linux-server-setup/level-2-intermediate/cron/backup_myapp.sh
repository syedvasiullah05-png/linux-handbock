#!/bin/bash
set -e

TS=$(date +%F_%H%M)
BACKUP_DIR=/var/backups/myapp
SRC=/srv/myapp

mkdir -p "$BACKUP_DIR"

tar -czf "${BACKUP_DIR}/myapp_${TS}.tar.gz" -C /srv myapp

ls -1t "${BACKUP_DIR}/myapp_"*.tar.gz | sed -e '1,14d' | xargs -r rm --

echo "Backup completed at $TS"
