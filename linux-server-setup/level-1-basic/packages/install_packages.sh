#!/bin/bash
set -e

# Detect package manager and install Git and Nginx
if command -v apt >/dev/null 2>&1; then
    echo "Detected apt (Debian/Ubuntu)..."
    sudo apt update
    sudo apt install -y git nginx
elif command -v yum >/dev/null 2>&1; then
    echo "Detected yum (Amazon Linux/CentOS)..."
    sudo yum install -y git nginx
elif command -v dnf >/dev/null 2>&1; then
    echo "Detected dnf (Fedora/RHEL)..."
    sudo dnf install -y git nginx
else
    echo "No supported package manager found. Exiting."
    exit 1
fi

# Enable and start Nginx
sudo systemctl enable --now nginx

echo "Installation complete. Nginx is running."
