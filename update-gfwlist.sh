curl -skLo /opt/gost/gfwlist.conf https://raw.githubusercontent.com/hq450/fancyss/master/rules/gfwlist.conf
sed -i 's/7913/15353/g' /opt/gost/gfwlist.conf
rm -f /etc/dnsmasq.d/gfwlist.conf | true
ln -s /opt/gost/gfwlist.conf /etc/dnsmasq.d/gfwlist.conf
systemctl restart dnsmasq
