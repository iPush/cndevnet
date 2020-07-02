curl -skLo /opt/qiangguo/gfwlist.conf https://raw.githubusercontent.com/hq450/fancyss/master/rules/gfwlist.conf
sed -i 's/7913/15353/g' /opt/qiangguo/gfwlist.conf
rm -f /etc/dnsmasq.d/gfwlist.conf | true
ln -s /opt/qiangguo/gfwlist.conf /etc/dnsmasq.d/gfwlist.conf
systemctl restart dnsmasq
