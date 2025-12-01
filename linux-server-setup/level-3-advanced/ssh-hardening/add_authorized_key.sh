#!/bin/bash

USER=$1

sudo mkdir -p /home/$USER/.ssh
sudo tee /home/$USER/.ssh/authorized_keys
sudo chmod 600 /home/$USER/.ssh/authorized_keys
sudo chown -R $USER:$USER /home/$USER/.ssh
