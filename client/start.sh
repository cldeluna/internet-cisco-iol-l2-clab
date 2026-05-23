#!/bin/sh
set -e

# Install test tools
apk add --no-cache curl openssh-client

# Get DHCP leases on all three interfaces
for iface in eth1 eth2 eth3; do
  udhcpc -i "$iface" -b -q

# Install and start SSH server so remote test harness can connect
apk add --no-cache curl openssh-client openssh-server

# Configure and start SSH so remote test harness can connect
ssh-keygen -A
echo "root:testpass" | chpasswd
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
/usr/sbin/sshd

# Get DHCP addresses on all three VLAN interfaces
for iface in eth1 eth2 eth3; do
  udhcpc -i "$iface" -b -q
done