#!/bin/bash

LOG_DIR=/srv/myapp/logs

find "$LOG_DIR" -type f -mtime +14 -print -delete

for f in "$LOG_DIR"/*.log; do
  [ -f "$f" ] || continue
  if [ $(stat -c%s "$f") -gt $((100*1024*1024)) ]; then
    mv "$f" "$f.$(date +%F_%H%M)"
    touch "$f"
  fi
done
