#!/bin/sh
set -e

# Install services
apk add --no-cache dnsmasq nginx openssh-server curl

# Static IPs — one per VLAN
ip addr add 192.0.2.10/24 dev eth1
ip addr add 198.51.100.10/24 dev eth2
ip addr add 203.0.113.10/24 dev eth3

# DHCP + DNS
dnsmasq --conf-file=/etc/dnsmasq.conf

# HTTP — default nginx welcome page is fine for testing
mkdir -p /run/nginx
nginx

# SSH
ssh-keygen -A
echo "root:testpass" | chpasswd
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
/usr/sbin/sshd