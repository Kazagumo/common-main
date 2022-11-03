#!/bin/sh

uci set luci.main.lang=zh_Hans
uci commit luci

uci set fstab.@global[0].anon_mount=1
uci commit fstab

set system.@system[0].timezone='CST-8'
set system.@system[0].zonename='Asia/Shanghai'
uci set system.@system[0].hostname='OpenWrt-123'
delete system.ntp.server
add_list system.ntp.server='ntp.tencent.com'
add_list system.ntp.server='ntp1.aliyun.com'
add_list system.ntp.server='ntp.ntsc.ac.cn'
add_list system.ntp.server='cn.ntp.org.cn'
uci commit system

uci set network.lan.ipaddr='192.168.2.2'
uci set network.lan.netmask='255.255.255.0'
uci set network.lan.gateway='192.168.2.1'
uci set network.lan.broadcast='192.168.2.255'
uci set network.lan.dns='223.5.5.5 114.114.114.114'
uci set network.lan.delegate='0'
uci commit network

uci set dhcp.@dnsmasq[0].filter_aaaa='1'
uci set dhcp.lan.ignore='1'
uci commit dhcp

sed -i 's,downloads.immortalwrt.org,mirrors.vsean.net/openwrt,g' /etc/opkg/distfeeds.conf

rm -f /www/luci-static/resources/view/status/include/50_dsl.js
rm -f /www/luci-static/resources/view/status/include/70_ddns.js
rm -f /www/luci-static/resources/view/status/include/80_minidlna.js
rm -f /www/luci-static/resources/view/status/include/80_upnp.js

ln -sf /sbin/ip /usr/bin/ip

[ -f '/bin/bash' ] && sed -i 's|root:x:0:0:root:/root:/bin/ash|root:x:0:0:root:/root:/bin/bash|g' /etc/passwd

sed -i '/option disabled/d' /etc/config/wireless
sed -i '/set wireless.radio${devidx}.disabled/d' /lib/wifi/mac80211.sh
wifi up

sed -i '/log-facility/d' /etc/dnsmasq.conf
echo "log-facility=/dev/null" >> /etc/dnsmasq.conf

rm -rf /tmp/luci-modulecache/
rm -f /tmp/luci-indexcache

mv /etc/openwrt_banner /etc/banner

sed -i '/DISTRIB_RELEAS/d' /etc/openwrt_release
echo "DISTRIB_RELEASE='SNAPSHOT'" >> /etc/openwrt_release
sed -i '/DISTRIB_REVISION/d' /etc/openwrt_release
echo "DISTRIB_REVISION='20.22'" >> /etc/openwrt_release
sed -i '/DISTRIB_DESCRIPTION/d' /etc/openwrt_release
echo "DISTRIB_DESCRIPTION='OpenWrt '" >> /etc/openwrt_release
sed -i '/luciname/d' /usr/lib/lua/luci/version.lua
sed -i '/luciversion/d' /usr/lib/lua/luci/version.lua
echo "luciname    = \"Immortalwrt-20.22\"" >> /usr/lib/lua/luci/version.lua

exit 0
