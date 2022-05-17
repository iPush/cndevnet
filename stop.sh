#!/bin/bash -
iptables -t nat -D OUTPUT -p tcp -j CNDEVNET
iptables -t nat -F CNDEVNET 
iptables -t nat -X CNDEVNET 

iptables -t mangle -D PREROUTING -j CNDEVNET
iptables -t mangle -D OUTPUT -j CNDEVNET_LOCAL
iptables -t mangle -F CNDEVNET
iptables -t mangle -X CNDEVNET
iptables -t mangle -F CNDEVNET_LOCAL
iptables -t mangle -N CNDEVNET_LOCAL

ip rule del fwmark 1 lookup 100
ip route del local default dev lo table 100

ipset destroy chnroute | true
ipset destroy cfroute | true
