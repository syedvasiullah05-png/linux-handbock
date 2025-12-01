#!/bin/bash

set -e

BASE="linux-server-setup"

echo "Creating project folder: $BASE"
mkdir -p $BASE

############################################
# LEVEL 1
############################################
mkdir -p $BASE/level-1-basic/users/sudoers
mkdir -p $BASE/level-1-basic/permissions
mkdir -p $BASE/level-1-basic/packages

# create_users.sh
cat <<'EOF' > $BASE/level-1-basic/users/create_users.sh
#!/bin/bash
set -e

echo "Creating group and users..."
sudo groupadd devs || true

sudo useradd -m -s /bin/bash -G devs alice || true
sudo useradd -m -s /bin/bash -G devs bob || true
sudo useradd -m -s /bin/bash -G devs ciuser || true

echo "Users created. Set passwords manually with: passwd <username>"
EOF

# sudoers file
cat <<'EOF' > $BASE/level-1-basic/users/sudoers/alice-dev
alice ALL=(ALL) NOPASSWD: /usr/bin/systemctl, /usr/bin/journalctl
EOF

# setup_project_dirs.sh
cat <<'EOF' > $BASE/level-1-basic/permissions/setup_project_dirs.sh
#!/bin/bash
set -e

sudo mkdir -p /srv/myapp/{logs,data}
sudo chown -R root:devs /srv/myapp
sudo chmod -R 2770 /srv/myapp

echo "/srv/myapp ready with devs group permissions"
EOF

# install_packages.sh
cat <<'EOF' > $BASE/level-1-basic/packages/install_packages.sh
#!/bin/bash

if command -v apt >/dev/null; then
  sudo apt update
  sudo apt install -y git nginx openjdk-17-jdk
else
  sudo dnf install -y git nginx java-17-openjdk-devel
fi

sudo systemctl enable --now nginx
EOF

############################################
# LEVEL 2
############################################
mkdir -p $BASE/level-2-intermediate/cron
mkdir -p $BASE/level-2-intermediate/logs
mkdir -p $BASE/level-2-intermediate/monitoring

# backup script
cat <<'EOF' > $BASE/level-2-intermediate/cron/backup_myapp.sh
#!/bin/bash
set -e

TS=$(date +%F_%H%M)
BACKUP_DIR=/var/backups/myapp
SRC=/srv/myapp

mkdir -p "$BACKUP_DIR"

tar -czf "${BACKUP_DIR}/myapp_${TS}.tar.gz" -C /srv myapp

ls -1t "${BACKUP_DIR}/myapp_"*.tar.gz | sed -e '1,14d' | xargs -r rm --

echo "Backup completed at $TS"
EOF

# cleanup logs
cat <<'EOF' > $BASE/level-2-intermediate/cron/cleanup_logs.sh
#!/bin/bash

LOG_DIR=/srv/myapp/logs

find "$LOG_DIR" -type f -mtime +14 -print -delete

for f in "$LOG_DIR"/*.log; do
  [ -f "$f" ] || continue
  if [ $(stat -c%s "$f") -gt $((100*1024*1024)) ]; then
    mv "$f" "$f.$(date +%F_%H%M)"
    touch "$f"
  fi
done
EOF

# health check
cat <<'EOF' > $BASE/level-2-intermediate/cron/app_health.sh
#!/bin/bash
set -e

URL="http://127.0.0.1:8080/health"

if curl -sSf "$URL" >/dev/null; then
  echo "$(date) HEALTHY"
else
  echo "$(date) UNHEALTHY — restarting"
  systemctl restart myapp.service
fi
EOF

# crontab examples
cat <<'EOF' > $BASE/level-2-intermediate/cron/crontab_examples.txt
# Daily backup at 2 AM
0 2 * * * /usr/local/bin/backup_myapp.sh

# Weekly log cleanup
0 3 * * 0 /usr/local/bin/cleanup_logs.sh

# Health check every 5 mins
*/5 * * * * /usr/local/bin/app_health.sh
EOF

# log notes
cat <<'EOF' > $BASE/level-2-intermediate/logs/log_management_notes.md
# Log Management Notes

- Application logs stored in `/srv/myapp/logs` or `/var/log/myapp`
- Use `journalctl -u <service>` for systemd logs
- Commands:
  - tail -F /var/log/syslog
  - journalctl -xe
  - du -sh /var/log/*
EOF

# monitoring commands
cat <<'EOF' > $BASE/level-2-intermediate/monitoring/monitoring_commands.md
# Monitoring Commands

## CPU & Memory
- lscpu
- free -h
- vmstat 1 5

## Disk
- lsblk
- df -hT

## Processes
- ps aux --sort=-%cpu | head
- top
- htop

## IO
- iostat 1 5
- iotop
EOF

############################################
# LEVEL 3
############################################
mkdir -p $BASE/level-3-advanced/systemd
mkdir -p $BASE/level-3-advanced/ssh-hardening
mkdir -p $BASE/level-3-advanced/lvm
mkdir -p $BASE/level-3-advanced/firewall
mkdir -p $BASE/level-3-advanced/logrotate

# systemd service
cat <<'EOF' > $BASE/level-3-advanced/systemd/myapp.service
[Unit]
Description=MyApp Java Service
After=network.target

[Service]
Type=simple
User=ciuser
Group=devs
WorkingDirectory=/srv/myapp
ExecStart=/srv/myapp/bin/start.sh
Restart=on-failure
RestartSec=5
StandardOutput=append:/var/log/myapp/myapp.out
StandardError=append:/var/log/myapp/myapp.err

[Install]
WantedBy=multi-user.target
EOF

# start.sh
cat <<'EOF' > $BASE/level-3-advanced/systemd/start.sh
#!/bin/bash
exec java -Xms512m -Xmx1g -jar /srv/myapp/myapp.jar
EOF

# SSH hardening notes
cat <<'EOF' > $BASE/level-3-advanced/ssh-hardening/sshd_config_changes.txt
PermitRootLogin no
PasswordAuthentication no
Protocol 2
Port 2222
EOF

# SSH key script
cat <<'EOF' > $BASE/level-3-advanced/ssh-hardening/add_authorized_key.sh
#!/bin/bash

USER=$1

sudo mkdir -p /home/$USER/.ssh
sudo tee /home/$USER/.ssh/authorized_keys
sudo chmod 600 /home/$USER/.ssh/authorized_keys
sudo chown -R $USER:$USER /home/$USER/.ssh
EOF

# LVM script
cat <<'EOF' > $BASE/level-3-advanced/lvm/lvm_setup_commands.sh
#!/bin/bash

sudo pvcreate /dev/sdb
sudo vgcreate vg_data /dev/sdb
sudo lvcreate -L 20G -n lv_myapp vg_data
sudo mkfs.ext4 /dev/vg_data/lv_myapp

sudo mkdir -p /data/myapp
sudo mount /dev/vg_data/lv_myapp /data/myapp

echo "/dev/vg_data/lv_myapp /data/myapp ext4 defaults 0 2" | sudo tee -a /etc/fstab
EOF

# UFW rules
cat <<'EOF' > $BASE/level-3-advanced/firewall/ufw_rules.sh
sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw allow 2222/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 8080/tcp

sudo ufw enable
EOF

# nftables rules
cat <<'EOF' > $BASE/level-3-advanced/firewall/nftables_rules.sh
sudo nft add table inet myfilter
sudo nft 'add chain inet myfilter input { type filter hook input priority 0; policy drop; }'
sudo nft 'add rule inet myfilter input ct state established,related accept'
sudo nft 'add rule inet myfilter input iif "lo" accept'
sudo nft 'add rule inet myfilter input tcp dport 2222 accept'
sudo nft 'add rule inet myfilter input tcp dport 80 accept'
sudo nft 'add rule inet myfilter input tcp dport 443 accept'
EOF

# logrotate
cat <<'EOF' > $BASE/level-3-advanced/logrotate/myapp.logrotate
/var/log/myapp/*.log /srv/myapp/logs/*.log {
    daily
    rotate 14
    compress
    delaycompress
    notifempty
    copytruncate
    sharedscripts
    postrotate
        systemctl reload myapp.service 2>/dev/null || true
    endscript
}
EOF

############################################
# README
############################################

cat <<'EOF' > $BASE/README.md
# Linux Server Setup – DevOps Bundle

Contains scripts and configs for:
- User & group setup
- Directory permissions
- Package installation
- Cron backups, log cleanup, health checks
- System monitoring
- Systemd application service
- SSH Hardening
- LVM storage setup
- Firewall rules
- Logrotate configuration

Run scripts with:
    chmod +x <script>.sh
    ./<script>.sh
EOF

############################################

echo "Making scripts executable..."
find $BASE -type f -name "*.sh" -exec chmod +x {} \;

echo "Done!"
echo "Project created at: $BASE/"

Collapse















Message Bharath M-16










