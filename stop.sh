#!/bin/bash -
iptables -t nat -F GOST 
iptables -t nat -X GOST 
iptables -t nat -D OUTPUT -p tcp -j GOST

ipset destroy chnroute | true
ipset destroy cfroute | true
