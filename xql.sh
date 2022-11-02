#!/bin/sh
sed -i '/DISTRIB_RELEAS/d' /etc/openwrt_release
echo "DISTRIB_RELEASE='SNAPSHOT'" >> /etc/openwrt_release
sed -i '/DISTRIB_REVISION/d' /etc/openwrt_release
echo "DISTRIB_REVISION='18.06'" >> /etc/openwrt_release
sed -i '/DISTRIB_DESCRIPTION/d' /etc/openwrt_release
echo "DISTRIB_DESCRIPTION='OpenWrt '" >> /etc/openwrt_release
sed -i '/luciname/d' /usr/lib/lua/luci/version.lua
sed -i '/luciversion/d' /usr/lib/lua/luci/version.lua
echo "luciname    = \"Immortalwrt-18.06\"" >> /usr/lib/lua/luci/version.lua
