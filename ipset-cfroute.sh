#curl -skLo cfroute.txt https://www.cloudflare.com/ips-v4

ipset destroy cfroute | true
ipset -N cfroute hash:net | true
cat cfroute.txt  | xargs -I % sh -c 'ipset add cfroute %'
