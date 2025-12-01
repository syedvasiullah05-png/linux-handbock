# Log Management Notes

- Application logs stored in `/srv/myapp/logs` or `/var/log/myapp`
- Use `journalctl -u <service>` for systemd logs
- Commands:
  - tail -F /var/log/syslog
  - journalctl -xe
  - du -sh /var/log/*
