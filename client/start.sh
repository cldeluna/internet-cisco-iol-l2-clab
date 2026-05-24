#!/bin/sh

apk add --no-cache curl openssh-client openssh-server

# SSH first
ssh-keygen -A
echo "root:testpass" | chpasswd
sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
/usr/sbin/sshd

# DHCP on each VLAN interface
for iface in eth1 eth2 eth3; do
  udhcpc -i "$iface" -b -q || true
done

# Wait for IPs to settle, then route to server through the switch
sleep 2
ip route add 192.168.1.0/24 via 192.0.2.1 dev eth1 || true