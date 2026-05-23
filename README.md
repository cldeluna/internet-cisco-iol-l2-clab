# Internet Cisco IOL Layer 2 Containerlab

This repository contains a Containerlab topology for a Cisco IOS-on-Linux (IOL) based Layer 2 lab environment.

Included files:
- `internet-cisco-iol-l3-lab.clab.yml`: Containerlab topology definition for the lab.
- `sw1.partial.cfg`: Example or partial switch configuration for the lab.

Use this repo to launch and test a simple Cisco L2 network topology using Containerlab and Cisco IOL images.


```mermaid

client                        server
   eth1  eth2  eth3             eth1  eth2  eth3
    │     │     │                 │     │     │
    │     │     │                 │     │     │
  e0/1  e0/2  e0/3             e1/0  e1/1  e1/2
        ┌─────────┐
        │   sw1   │
        │  (L2)   │
        └─────────┘
```

File Structure:iol-lab/
├── iol-lab.clab.yml
├── sw1.partial.cfg
├── server/
│   ├── dnsmasq.conf
│   └── start.sh
└── client/
    └── start.sh

# TESTING

## Shell into the client
docker exec -it clab-iol-lab-client sh

#$ Verify DHCP leases
ip addr show eth1
ip addr show eth2
ip addr show eth3

## Test HTTP through the ACL
curl http://192.0.2.10
curl http://198.51.100.10
curl http://203.0.113.10

## Test SSH through the ACL
ssh root@192.0.2.10       # password: testpass

## Test DNS through the ACL
nslookup google.com 192.0.2.10