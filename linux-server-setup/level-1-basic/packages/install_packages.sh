#!/bin/bash
if command -v apt >/dev/null; then
  sudo apt update
 sudo yum install -y git nginx
 else
 udo dnf install -y git nginx
fi

sudo systemctl enable --now nginx
