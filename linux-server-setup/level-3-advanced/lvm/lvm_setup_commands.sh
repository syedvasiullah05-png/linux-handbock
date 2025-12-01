#!/bin/bash

sudo pvcreate /dev/sdb
sudo vgcreate vg_data /dev/sdb
sudo lvcreate -L 20G -n lv_myapp vg_data
sudo mkfs.ext4 /dev/vg_data/lv_myapp

sudo mkdir -p /data/myapp
sudo mount /dev/vg_data/lv_myapp /data/myapp

echo "/dev/vg_data/lv_myapp /data/myapp ext4 defaults 0 2" | sudo tee -a /etc/fstab
