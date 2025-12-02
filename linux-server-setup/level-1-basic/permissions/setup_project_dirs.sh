#!/bin/bash
set -e

# Create devs group if it doesn't exist
if ! getent group devs >/dev/null; then
    echo "Creating group 'devs'..."
    sudo groupadd devs
fi

# Create the directory structure
echo "Creating /srv/myapp directories..."
sudo mkdir -p /srv/myapp/{logs,data}

# Set ownership and permissions
echo "Setting ownership to root:devs and permissions to 2770..."
sudo chown -R root:devs /srv/myapp
sudo chmod -R 2770 /srv/myapp

echo "/srv/myapp ready with 'devs' group per
