#!/bin/sh -

## IPSET
# OR ipset create gfwlist hash:ip
ipset -N gfwlist iphash

# Telegram IP Range from https://ipinfo.io/AS62041
ipset add gfwlist 149.154.160.0/20
ipset add gfwlist 149.154.164.0/22
ipset add gfwlist 91.108.4.0/22
ipset add gfwlist 91.108.56.0/22
ipset add gfwlist 91.108.8.0/22

## NAT
# 在 nat 表中创建链
iptables -t nat -N GFWLIST
iptables -t nat -N TUNNEL

# 所有的 tcp 都转发到 TUNNEL
iptables -t nat -I PREROUTING 1 -p tcp -j TUNNEL

# 跳过一些不需要转发的 IP，如本地 IP，局域网 IP，组播 IP等特殊用途的 IP
iptables -t nat -A TUNNEL -d 0.0.0.0/8 -j RETURN
iptables -t nat -A TUNNEL -d 127.0.0.0/8 -j RETURN
iptables -t nat -A TUNNEL -d 10.0.0.0/8 -j RETURN
iptables -t nat -A TUNNEL -d 192.168.0.0/16 -j RETURN
iptables -t nat -A TUNNEL -d 224.0.0.0/4 -j RETURN
iptables -t nat -A TUNNEL -d 240.0.0.0/4 -j RETURN

# 跳过代理服务器 IP
SERVER_TXT_PATH=$(dirname $(readlink -f "$0"))/server.txt
cat ${SERVER_TXT_PATH} | xargs -I % sh -c 'iptables -t nat -A TUNNEL -d % -j RETURN'

# 剩下的 IP 到转发到 GFWLIST 进行检查
iptables -t nat -A TUNNEL -p tcp -j GFWLIST

# 如果 IP 在 gfwlist 中，则转发到端口 1081
iptables -t nat -A GFWLIST -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-port 1081
