#!/bin/sh -

iptables -t nat -D PREROUTING -p tcp -j TUNNEL | true
iptables -t nat -F GFWLIST | true
iptables -t nat -X GFWLIST | true
iptables -t nat -F TUNNEL | true
iptables -t nat -X TUNNEL | true
ipset destroy gfwlist | true
