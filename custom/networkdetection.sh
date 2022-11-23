#!/bin/bash

curl --connect-timeout 10 "baidu.com" > "/dev/null" 2>&1 || wangluo='1'
if [[ "${wangluo}" == "1" ]]; then
  curl --connect-timeout 10 "taobao.com" > "/dev/null" 2>&1 || wangluo='2'
fi
if [[ "${wangluo}" == "2" ]]; then
  curl --connect-timeout 10 "google.com" > "/dev/null" 2>&1 || wangluo='2'
fi
if [[ "${wangluo}" == "1" ]] && [[ "${wangluo}" == "2" ]] && [[ "${wangluo}" == "3" ]]; then
  echo "[没检测到网络，重启系统于$(date "+%Y年%m月%d日%H时%M分%S秒")]" >> /mnt/network.log
  reboot -f
else
  echo "[$(date "+%Y年%m月%d日%H时%M分%S秒")-网络正常]" >> /mnt/network.log
fi
