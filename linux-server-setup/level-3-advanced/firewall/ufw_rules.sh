sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw allow 2222/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 8080/tcp

sudo ufw enable
