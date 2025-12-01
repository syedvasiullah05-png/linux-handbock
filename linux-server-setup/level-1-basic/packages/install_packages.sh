#!/bin/bash

if command -v apt >/dev/null; then
  sudo apt update
  sudo apt install -y git nginx openjdk-17-jdk
else
  sudo dnf install -y git nginx java-17-openjdk-devel
fi

sudo systemctl enable --now nginx
