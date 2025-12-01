#!/bin/bash
set -e

echo "Creating group and users..."
sudo groupadd devs || true

sudo useradd -m -s /bin/bash -G devs alice || true
sudo useradd -m -s /bin/bash -G devs bob || true
sudo useradd -m -s /bin/bash -G devs ciuser || true

echo "Users created. Set passwords manually with: passwd <username>"
