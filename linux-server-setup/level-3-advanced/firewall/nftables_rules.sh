sudo nft add table inet myfilter
sudo nft 'add chain inet myfilter input { type filter hook input priority 0; policy drop; }'
sudo nft 'add rule inet myfilter input ct state established,related accept'
sudo nft 'add rule inet myfilter input iif "lo" accept'
sudo nft 'add rule inet myfilter input tcp dport 2222 accept'
sudo nft 'add rule inet myfilter input tcp dport 80 accept'
sudo nft 'add rule inet myfilter input tcp dport 443 accept'
