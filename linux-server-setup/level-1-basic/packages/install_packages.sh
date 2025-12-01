#!/bin/bash

echo "Installing Nginx..."

if command -v apt >/dev/null; then

elif command -v yum >/dev/null; then
    sudo yum install nginx -y

else
    echo "OS not supported"
    exit 1
fi
sudo systemctl start nginx
sudo systemctl enable nginx
