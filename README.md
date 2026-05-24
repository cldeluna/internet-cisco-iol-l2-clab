# Internet Cisco IOL Layer 2 Containerlab

This repository contains a Containerlab topology for a Cisco IOS-on-Linux (IOL) based Layer 2 lab environment with a routed server VLAN.

Included files:
- `internet-cisco-iol-l3-lab.clab.yml`: Containerlab topology definition for the lab.
- `sw1.partial.cfg`: Cisco IOL switch configuration for the core switch.
- `server/dnsmasq.conf`: DHCP/DNS configuration for the server container.
- `server/start.sh`: Server container startup script.
- `client/start.sh`: Client container startup script.

Use this repo to deploy and test a Cisco L2 topology where a client network is routed to a server VLAN through a Cisco IOL switch.

```mermaid

client                        server
   eth1  eth2  eth3               eth1
    │     │     │                 │
    │     │     │                 │
  e0/1  e0/2  e0/3                 e1/0
        ┌──────────┐
        │ core-sw1 │
        │  (L2)    │
        └──────────┘
```

File structure:
- `internet-cisco-iol-l3-lab.clab.yml`
- `sw1.partial.cfg`
- `server/dnsmasq.conf`
- `server/start.sh`
- `client/start.sh`

# TESTING

## Deploy the lab
```sh
containerlab deploy --topo internet-cisco-iol-l3-lab.clab.yml
```

## Shell into the client
```sh
docker exec -it clab-internet-cisco-iol-l2-lab-client sh
```

## Verify VLAN interfaces on the client
```sh
ip addr show eth1
ip addr show eth2
ip addr show eth3
```

## Verify server reachability
```sh
curl http://192.168.1.10
ssh root@192.168.1.10  # password: testpass
nslookup google.com 192.168.1.10
```

## Verify DHCP leases on server
```sh
docker exec clab-internet-cisco-iol-l2-lab-server cat /var/lib/misc/dnsmasq.leases
```

## Handy commands
```sh
clab destroy --cleanup
sudo docker logs -f clab-internet-cisco-iol-l2-lab-core-sw1
ssh-keygen -f "/home/claudia/.ssh/known_hosts" -R "172.20.20.2"
```
