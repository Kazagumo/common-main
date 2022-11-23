#!/bin/sh
# https://github.com/Hyy2001X/AutoBuild-Actions
# AutoBuild Module by Hyy2001
# AutoUpdate for Openwrt

Input_Option=$1

function information_acquisition() {
source /bin/openwrt_info
Kernel=$(egrep -o "[0-9]+\.[0-9]+\.[0-9]+" /usr/lib/opkg/info/kernel.control)
[ ! -d "${Download_Path}" ] && mkdir -p ${Download_Path} || rm -rf "${Download_Path}"/*
opkg list | awk '{print $1}' > ${Download_Path}/Installed_PKG_List
PKG_List="${Download_Path}/Installed_PKG_List"

curl --connect-timeout 5 "baidu.com" > "/dev/null" 2>&1 || wangluo='1'
if [[ "${wangluo}" == "1" ]]; then
  curl --connect-timeout 5 "google.com" > "/dev/null" 2>&1 || wangluo='2'
fi
if [[ "${wangluo}" == "1" ]] && [[ "${wangluo}" == "2" ]]; then
  echo "您可能没进行联网,请检查网络,或您的网络不能连接百度?" > /tmp/cloud_version
  exit 1
fi

Google_Check=$(curl -I -s --connect-timeout 8 google.com -w %{http_code} | tail -n1)
if [ ! "${Google_Check}" == 301 ]; then
  DOWNLOAD=https://ghproxy.com/${Release_download}
  wget -q https://ghproxy.com/${Github_API2} -O ${API_PATH}
else
  DOWNLOAD=${Release_download}
  wget -q ${Github_API1} -O ${API_PATH}
fi
if [[ $? -ne 0 ]];then
  echo "获取API数据失败,Github地址不正确，或此地址没云端存在，或您的仓库为私库!" > /tmp/cloud_version
  exit 1
fi

case "${TARGET_BOARD}" in
x86)
  [ -d '/sys/firmware/efi' ] && {
    BOOT_Type=uefi
  } || {
    BOOT_Type=legacy
  }
  CURRENT_Device=$(cat /proc/cpuinfo |grep 'model name' |awk 'END {print}' |cut -f2 -d: |sed 's/^[ ]*//g'|sed 's/\ CPU//g')
;;
*)
  CURRENT_Device="$(jsonfilter -e '@.model.id' < /etc/board.json | tr ',' '_')"
  BOOT_Type=sysupgrade
esac

CLOUD_Firmware=$(egrep -o "${CLOUD_CHAZHAO}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')
CLOUD_Version=$(echo "${CLOUD_Version}"|egrep -o [0-9]+[0-9]+[0-9]+[0-9]+[0-9]+[0-9]+[0-9]+[0-9]+[0-9]+[0-9]+[0-9]+[0-9]+)
LUCI_Firmware=$(echo ${CLOUD_Version} | egrep -o "${SOURCE}-${DEFAULT_Device}-[0-9]+")
if [[ -z "${CLOUD_Version}" ]]; then
  echo "获取云端固件版本信息失败,如果是x86的话,注意固件的引导模式是否对应,或者是蛋痛的脚本作者修改过脚本导致固件版本信息不一致!" > /tmp/cloud_version
  exit 1
fi

cat > /tmp/Version_Tags <<-EOF
LOCAL_Version=${LOCAL_Version}
CLOUD_Version=${CLOUD_Version}
LUCI_Firmware=${LUCI_Firmware}
EOF
cat > /etc/openwrt_upgrade <<-EOF
LUCI_Firmware=${LUCI_Firmware}
MODEL_type=${BOOT_Type}${Firmware_SFX}
KERNEL_type=${Kernel} - ${LUCI_EDITION}
CURRENT_Device=${CURRENT_Device}
EOF
echo "信息检测完毕"
}

function firmware_upgrade() {
TMP_Available=$(df -m | grep "/tmp" | awk '{print $4}' | awk 'NR==1' | awk -F. '{print $1}')
let X=$(grep -n "${CLOUD_Firmware}" ${API_PATH} | tail -1 | cut -d : -f 1)-4
let CLOUD_Firmware_Size=$(sed -n "${X}p" ${API_PATH} | egrep -o "[0-9]+" | awk '{print ($1)/1048576}' | awk -F. '{print $1}')+1
if [[ "${TMP_Available}" -lt "${CLOUD_Firmware_Size}" ]]; then
  echo "固件tmp空间值[${TMP_Available}M],云端固件体积[${CLOUD_Firmware_Size}M],空间不足，不能下载" > /tmp/cloud_version
  exit 1
else
  echo "${TMP_Available}  ${CLOUD_Firmware_Size}"
fi

if [[ "${LOCAL_Version}" -lt "${CLOUD_Version}" ]]; then
  echo "检测到有可更新的固件版本,立即更新固件!"
else
  echo "${LOCAL_Version} = ${CLOUD_Version}"
  echo "已是最新版本，无需更新固件!"
  exit 0
fi

cd "${Download_Path}"
echo "正在下载云端固件,请耐心等待..." > /tmp/cloud_version
wget -q "${DOWNLOAD}/${CLOUD_Firmware}" -O ${CLOUD_Firmware}
if [[ $? -ne 0 ]];then
curl -# -L -O "${DOWNLOAD}/${CLOUD_Firmware}"
fi
if [[ $? -ne 0 ]];then
   echo "下载云端固件失败,请检查网络再尝试或手动安装固件!" > /tmp/cloud_version
   exit 1
else
  echo "下载云端固件成功!" > /tmp/cloud_version
  echo "下载云端固件"
fi

export LOCAL_MD5=$(md5sum ${CLOUD_Firmware} | cut -c1-3)
export LOCAL_256=$(sha256sum ${CLOUD_Firmware} | cut -c1-3)
export MD5_256=$(echo ${CLOUD_Firmware} | egrep -o "[a-zA-Z0-9]+${Firmware_SFX}" | sed -r "s/(.*)${Firmware_SFX}/\1/")
export CLOUD_MD5="$(echo "${MD5_256}" | cut -c1-3)"
export CLOUD_256="$(echo "${MD5_256}" | cut -c 4-)"
if [[ ! "${LOCAL_MD5}" == "${CLOUD_MD5}" ]]; then
  echo "MD5对比失败,固件可能在下载时损坏,请检查网络后重试!" > /tmp/cloud_version
  exit 1
fi
if [[ ! "${LOCAL_256}" == "${CLOUD_256}" ]]; then
  echo "SHA256对比失败,固件可能在下载时损坏,请检查网络后重试!" > /tmp/cloud_version
  exit 1
fi

cd "${Download_Path}"
echo "正在执行"${Update_explain}",更新期间请不要断开电源或重启设备 ..." > /tmp/cloud_version
chmod 777 "${CLOUD_Firmware}"
[[ "$(cat ${PKG_List})" =~ "gzip" ]] && opkg remove gzip > /dev/null 2>&1
sleep 2
if [[ -f "/etc/deletefile" ]]; then
  chmod 775 "/etc/deletefile"
  source /etc/deletefile
fi
rm -rf /etc/config/luci
echo "*/5 * * * * sh /etc/networkdetection > /dev/null 2>&1" >> /etc/crontabs/root
rm -rf /mnt/*upback.tar.gz && sysupgrade -b /mnt/upback.tar.gz
if [[ `ls -1 /mnt | grep -c "upback.tar.gz"` -eq '1' ]]; then
  Upgrade_Options='sysupgrade -f /mnt/upback.tar.gz'
  echo "${Upgrade_Options}"
else
  Upgrade_Options='sysupgrade -q'
  echo "${Upgrade_Options}"
fi
echo "升级固件中，请勿断开路由器电源"
${Upgrade_Options} ${CLOUD_Firmware}
}


if [[ -z "${Input_Option}" ]]; then
api_data
else
  case ${Input_Option} in
  -u)
  information_acquisition
  firmware_upgrade
  ;;
  esac
fi
