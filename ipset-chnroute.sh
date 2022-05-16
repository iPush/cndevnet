#!/bin/bash -
#curl -skLo chnroute.txt https://raw.githubusercontent.com/17mon/china_ip_list/master/china_ip_list.txt

ipset destroy chnroute | true
ipset -N chnroute hash:net | true
cat chnroute.txt  | xargs -I % sh -c 'ipset add chnroute %'
