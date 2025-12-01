#!/bin/bash
set -e

URL="http://127.0.0.1:8080/health"

if curl -sSf "$URL" >/dev/null; then
  echo "$(date) HEALTHY"
else
  echo "$(date) UNHEALTHY — restarting"
  systemctl restart myapp.service
fi
