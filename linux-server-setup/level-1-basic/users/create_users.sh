#!/bin/bash
set -e

echo "Creating group 'devs' if it doesn't exist..."
if ! getent group devs >/dev/null; then
    sudo groupadd devs
fi

echo "Creating users and adding them to 'devs' group..."

for user in alice bob ciuser; do
    if id "$user" >/dev/null 2>&1; then
        echo "User $user already exists, skipping..."
    else
        sudo useradd -m -s /bin/bash -G devs "$user"
        echo "User $user created."
    fi
done

echo "Users created. Set passwords manually with: sudo passwd <username>"
