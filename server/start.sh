#!/bin/sh

apk add --no-cache dnsmasq nginx openssh-server curl

# Start SSH first so the container is reachable regardless
ssh-keygen -A
echo "root:testpass" | chpasswd
sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
/usr/sbin/sshd

# Static IPs on each VLAN interface
ip addr add 192.0.2.10/24 dev eth1
ip addr add 198.51.100.10/24 dev eth2
ip addr add 203.0.113.10/24 dev eth3

# Web content
echo 'ACL test OK!' > /var/lib/nginx/html/index.html

# Start services
dnsmasq --conf-file=/etc/dnsmasq.conf || true
mkdir -p /run/nginx
nginx || true