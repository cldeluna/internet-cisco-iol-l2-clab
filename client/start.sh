#!/bin/sh

apk add --no-cache curl openssh-client openssh-server

# Start SSH server first so remote access is available immediately
ssh-keygen -A
echo "root:testpass" | chpasswd
sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
/usr/sbin/sshd

# DHCP can fail if the switch isn't ready yet — don't let it kill the script
for iface in eth1 eth2 eth3; do
  udhcpc -i "$iface" -b -q || true
done