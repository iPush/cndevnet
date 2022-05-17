#!/bin/bash -
./ipset-cfroute.sh
./ipset-chnroute.sh

iptables -t nat -N CNDEVNET | true

# Ignore LANs and  reserved addresses.
iptables -t nat -A CNDEVNET -d 0.0.0.0/8 -j RETURN
iptables -t nat -A CNDEVNET -d 10.0.0.0/8 -j RETURN
iptables -t nat -A CNDEVNET -d 172.16.0.0/12 -j RETURN
iptables -t nat -A CNDEVNET -d 192.168.0.0/16 -j RETURN
iptables -t nat -A CNDEVNET -d 127.0.0.0/8 -j RETURN
iptables -t nat -A CNDEVNET -d 169.254.0.0/16 -j RETURN
iptables -t nat -A CNDEVNET -d 224.0.0.0/4 -j RETURN
iptables -t nat -A CNDEVNET -d 240.0.0.0/4 -j RETURN

# Ignore Your Server IP
# iptables -t nat -A CNDEVNET -d 1.2.3.4/32 -j RETURN

# Ignore China IP
iptables -t nat -A CNDEVNET -p tcp -m set --match-set chnroute dst -j RETURN

# Ignore Cloudflare IP
iptables -t nat -A CNDEVNET -p tcp -m set --match-set cfroute dst -j RETURN

# Anything else should be redirected to port 12345
iptables -t nat -A CNDEVNET -p tcp -j REDIRECT --to-ports 12345 

# All tcp output to CNDEVNET
iptables -t nat -A OUTPUT -p tcp -j CNDEVNET

# Proxy UDP packet
iptables -t mangle -N CNDEVNET
iptables -t mangle -N CNDEVNET_LOCAL

# Ignore LANs and  reserved addresses.
iptables -t mangle -A CNDEVNET -d 127.0.0.0/8 -p udp -j RETURN
iptables -t mangle -A CNDEVNET -d 10.0.0.0/8 -p udp -j RETURN
iptables -t mangle -A CNDEVNET -d 192.168.0.0/16 -p udp -j RETURN
iptables -t mangle -A CNDEVNET -d 172.16.0.0/12 -p udp -j RETURN
iptables -t mangle -A CNDEVNET -d 255.255.255.255/32 -j RETURN

# Ignore China IP
iptables -t mangle -A CNDEVNET -p udp -m set --match-set chnroute dst -j RETURN

# Ignore Cloudflare IP
iptables -t mangle -A CNDEVNET -p udp -m set --match-set cfroute dst -j RETURN

# Anything else should be redirected to udp port 12345
iptables -t mangle -A CNDEVNET -p udp -j TPROXY --on-port 12345 --on-ip 127.0.0.1 --tproxy-mark 1

# Set TPROXY mark
iptables -t mangle -A CNDEVNET_LOCAL -d 127.0.0.0/8 -p udp -j RETURN
iptables -t mangle -A CNDEVNET_LOCAL -d 10.0.0.0/8 -p udp -j RETURN
iptables -t mangle -A CNDEVNET_LOCAL -d 192.168.0.0/16 -p udp -j RETURN
iptables -t mangle -A CNDEVNET_LOCAL -d 172.16.0.0/12 -p udp -j RETURN
iptables -t mangle -A CNDEVNET_LOCAL -d 255.255.255.255/32 -j RETURN
iptables -t mangle -A CNDEVNET_LOCAL -p udp -j MARK --set-mark 1

# All udp output to CNDEVNET
iptables -t mangle -A PREROUTING -j CNDEVNET
iptables -t mangle -A OUTPUT -j CNDEVNET_LOCAL

# IP Table for TProxy
ip rule add fwmark 1 lookup 100
ip route add local default dev lo table 100