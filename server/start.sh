#!/bin/sh

apk add --no-cache dnsmasq nginx openssh-server curl

# SSH first
ssh-keygen -A
echo "root:testpass" | chpasswd
sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
/usr/sbin/sshd

# Single interface on server VLAN
ip addr add 192.168.1.10/24 dev eth1

# Routes to client subnets go through the switch (not management)
ip route add 192.0.2.0/24 via 192.168.1.1 dev eth1
ip route add 198.51.100.0/24 via 192.168.1.1 dev eth1
ip route add 203.0.113.0/24 via 192.168.1.1 dev eth1

# Web content
echo 'ACL test OK!' > /var/lib/nginx/html/index.html

# Start services
dnsmasq --conf-file=/etc/dnsmasq.conf || true
mkdir -p /run/nginx
nginx || true