#!/bin/bash -
./ipset-cfroute.sh
./ipset-chnroute.sh

iptables -t nat -N GOST | true

# Ignore LANs and  reserved addresses.
iptables -t nat -A GOST -d 0.0.0.0/8 -j RETURN
iptables -t nat -A GOST -d 10.0.0.0/8 -j RETURN
iptables -t nat -A GOST -d 127.0.0.0/8 -j RETURN
iptables -t nat -A GOST -d 169.254.0.0/16 -j RETURN
iptables -t nat -A GOST -d 172.16.0.0/12 -j RETURN
iptables -t nat -A GOST -d 192.168.0.0/16 -j RETURN
iptables -t nat -A GOST -d 224.0.0.0/4 -j RETURN
iptables -t nat -A GOST -d 240.0.0.0/4 -j RETURN

# Ignore Server IP
iptables -t nat -A GOST -d 103.79.78.104/32 -j RETURN

# Ignore China IP
iptables -t nat -A GOST -p tcp -m set --match-set chnroute dst -j RETURN

# Ignore Cloudflare IP
iptables -t nat -A GOST -p tcp -m set --match-set cfroute dst -j RETURN

# Anything else should be redirected to port 12345
iptables -t nat -A GOST -p tcp -j REDIRECT --to-ports 12345 

iptables -t nat -A OUTPUT -p tcp -j GOST
# iptables -t nat -A OUTPUT -p tcp --dport 443 -j GOST
# iptables -t nat -A OUTPUT -p tcp --dport 80 -j GOST
