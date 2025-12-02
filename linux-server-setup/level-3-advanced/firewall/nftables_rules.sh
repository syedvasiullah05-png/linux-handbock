#!/bin/bash
set -e

# Create a new nftables table 'myfilter' in the inet family if it doesn't exist
if ! sudo nft list tables | grep -q '^table inet myfilter$'; then
    echo "Creating nftables table 'myfilter'..."
    sudo nft add table inet myfilter
fi

# Create the input chain with default drop policy if it doesn't exist
if ! sudo nft list chain inet myfilter input >/dev/null 2>&1; then
    echo "Creating input chain with default drop policy..."
    sudo nft 'add chain inet myfilter input { type filter hook input priority 0; policy drop; }'
fi

# Allow established and related connections
sudo nft 'add rule inet myfilter input ct state established,related accept'

# Allow loopback interface
sudo nft 'add rule inet myfilter input iif "lo" accept'

# Allow SSH on custom port 2222
sudo nft 'add rule inet myfilter input tcp dport 2222 accept'

# Allow HTTP and HTTPS
sudo nft 'add rule inet myfilter input tcp dport 80 accept'
sudo nft 'add rule inet myfilter input tcp dport 443 accept'

echo "Firewall rules applied successfully."
