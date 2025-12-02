#!/bin/bash

echo "Installing Nginx..."

if command -v apt >/dev/null; then
    sudo apt update
    sudo apt install nginx -y
elif command -v yum >/dev/null; then
    sudo yum install nginx -y
else
    echo "OS not supported"
    exit 1
fi

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

echo "Nginx installation completed."

