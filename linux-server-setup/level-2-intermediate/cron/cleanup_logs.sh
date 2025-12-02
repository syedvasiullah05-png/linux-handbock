#!/bin/bash
set -e

LOG_DIR=/srv/myapp/logs
MAX_SIZE=$((100*1024*1024))  # 100 MB

# Delete logs older than 14 days
sudo find "$LOG_DIR" -type f -mtime +14 -print -delete

# Rotate logs larger than 100 MB
for f in "$LOG_DIR"/*.log; do
    [ -f "$f" ] || continue
    FILE_SIZE=$(stat -c%s "$f")
    if [ "$FILE_SIZE" -gt "$MAX_SIZE" ]; then
        TIMESTAMP=$(date +%F_%H%M)
        sudo mv "$f" "$f.$TIMESTAMP"
        sudo touch "$f"
        echo "Rotated $f -> $f.$TIMESTAMP"
    fi
done
