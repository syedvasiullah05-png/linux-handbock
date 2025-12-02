#!/bin/bash
set -e

# URL to check
URL="http://127.0.0.1:8080/health"

# Check health
if curl -sSf "$URL" >/dev/null; then
    echo "$(date) HEALTHY"
else
    echo "$(date) UNHEALTHY — restarting myapp.service"
    sudo systemctl restart myapp.service
fi
