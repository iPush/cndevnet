#!/bin/bash -
iptables -t nat -F CNDEVNET 
iptables -t nat -X CNDEVNET 
iptables -t nat -D OUTPUT -p tcp -j CNDEVNET

ipset destroy chnroute | true
ipset destroy cfroute | true
