#!/bin/bash
set -e

sudo mkdir -p /srv/myapp/{logs,data}
sudo chown -R root:devs /srv/myapp
sudo chmod -R 2770 /srv/myapp

echo "/srv/myapp ready with devs group permissions"
