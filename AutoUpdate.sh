#!/bin/sh
# https://github.com/Hyy2001X/AutoBuild-Actions
# AutoBuild Module by Hyy2001
# AutoUpdate for Openwrt

White="\033[0;37m"
Yellow="\033[0;33m"
White="\033[0;37m"
Yellow="\033[0;33m"
Red="\033[1;91m"
Blue="\033[0;94m"
BLUEB="\033[1;94m"
BCyan="\033[1;36m"
Grey="\033[1;34m"
Green="\033[0;92m"
Purple="\033[1;95m"
TIME() {
  local Color
  [[ -z $1 ]] && {
    echo -ne "\n${Grey}[$(date "+%H:%M:%S")]${White} "
  } || {
  case $1 in
    r) Color="${Red}";;
    g) Color="${Green}";;
    b) Color="${Blue}";;
    B) Color="${BLUEB}";;
    y) Color="${Yellow}";;
    h) Color="${BCyan}";;
    z) Color="${Purple}";;
    x) Color="${Grey}";;
  esac
    [[ $# -lt 2 ]] && {
      echo -e "\n${Grey}[$(date "+%H:%M:%S")]${White} $1"
      LOGGER $1
    } || {
      echo -e "\n${Grey}[$(date "+%H:%M:%S")]${White} ${Color}$2${White}"
      LOGGER $2
    }
  }
}

if [[ ! -f "/bin/openwrt_info" ]]; then
  echo "未检测到固件更新应用程序,无法运行程序!" > /tmp/cloud_version
else
  chmod +x /bin/openwrt_info
  source /bin/openwrt_info
fi

export Kernel="$(egrep -o "[0-9]+\.[0-9]+\.[0-9]+" /usr/lib/opkg/info/kernel.control)"
export Overlay_Available="$(df -h | grep ":/overlay" | awk '{print $4}' | awk 'NR==1')"
export TMP_Available="$(df -m | grep "/tmp" | awk '{print $4}' | awk 'NR==1' | awk -F. '{print $1}')"
[ ! -d "${Download_Path}" ] && mkdir -p ${Download_Path} || rm -rf "${Download_Path}"/*
opkg list | awk '{print $1}' > ${Download_Path}/Installed_PKG_List
export PKG_List="${Download_Path}/Installed_PKG_List"
export AutoUpdate_Log_Path="/tmp"

function lian_wang() {
curl --connect-timeout 6 -o /tmp/baidu.html -s -w %{time_namelookup}: http://www.baidu.com > /dev/null 2>&1
if [[ -f /tmp/baidu.html ]] && [[ `grep -c "百度一下" /tmp/baidu.html` -ge '1' ]]; then
  rm -rf /tmp/baidu.html
else
  echo "您可能没进行联网,请检查网络,或您的网络不能连接百度?" > /tmp/cloud_version
  exit 1
fi
}

function api_data() {
[ ! -d ${Download_Path} ] && mkdir -p ${Download_Path}
wget -q https://ghproxy.com/${Github_API2} -O ${API_PATH}
if [[ $? -ne 0 ]];then
  wget --no-check-certificate --content-disposition -q -T 6 -t 2 ${Github_API1} -O ${API_PATH}
fi
if [[ $? -ne 0 ]];then
  echo "获取API数据失败,Github地址不正确，或此地址没云端存在，或您的仓库为私库!" > /tmp/cloud_version
  exit 1
fi
}

function model_name() {
case "${TARGET_BOARD}" in
x86)
  [ -d /sys/firmware/efi ] && {
    export BOOT_Type="uefi"
  } || {
    export BOOT_Type="legacy"
  }
  export CPUmodel="$(cat /proc/cpuinfo |grep 'model name' |awk 'END {print}' |cut -f2 -d: |sed 's/^[ ]*//g'|sed 's/\ CPU//g')"
  if [[ "$(echo ${CPUmodel} |grep -c 'Intel')" -ge '1' ]]; then
    export Cpu_Device="$(echo "${CPUmodel}" |awk '{print $2}')"
    export CURRENT_Device="$(echo "${CPUmodel}" |sed "s/${Cpu_Device}//g")"
  else
    export CURRENT_Device="${CPUmodel}"
  fi
;;
rockchip | bcm27xx | mxs | sunxi | zynq)
  [ -d /sys/firmware/efi ] && {
    export BOOT_Type="uefi"
  } || {
    export BOOT_Type="legacy"
  }
  export CURRENT_Device="$(jsonfilter -e '@.model.id' < /etc/board.json | tr ',' '_')"
;;
mvebu)
  case "${TARGET_SUBTARGET}" in
  cortexa53 | cortexa72)
    [ -d /sys/firmware/efi ] && {
      export BOOT_Type="uefi"
    } || {
      export BOOT_Type="legacy"
    }
    export CURRENT_Device="$(jsonfilter -e '@.model.id' < /etc/board.json | tr ',' '_')"
  ;;
  esac
;;
*)
  export CURRENT_Device="$(jsonfilter -e '@.model.id' < /etc/board.json | tr ',' '_')"
  export BOOT_Type="sysupgrade"
esac
}

function cloud_Version() {
# 搞出本地版本固件名字用作显示用途
export LOCAL_Version="$(egrep -o "${LOCAL_CHAZHAO}-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
export LOCAL_Firmware="$(grep 'CURRENT_Version=' "/bin/openwrt_info" | cut -d "=" -f2)"
if [[ -z "${LOCAL_Version}" ]]; then
  export LOCAL_Version="云端有没发现您现在安装的固件版本存在"
fi
echo "${LOCAL_Version}" > /etc/local_Version

export CLOUD_Version="$(egrep -o "${CLOUD_CHAZHAO}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
export CLOUD_Firmware="$(echo ${CLOUD_Version} | egrep -o "${SOURCE}-${DEFAULT_Device}-[0-9]+")"
if [[ -z "${CLOUD_Version}" ]]; then
  echo "获取云端固件版本信息失败,如果是x86的话,注意固件的引导模式是否对应,或者是蛋痛的脚本作者修改过脚本导致固件版本信息不一致!" > /tmp/cloud_version
  exit 1
fi
}

function record_version() {
cat > /tmp/Version_Tags <<-EOF
LOCAL_Firmware=${LOCAL_Firmware}
CLOUD_Firmware=${CLOUD_Firmware}
EOF
cat > /etc/openwrt_upgrade <<-EOF
LOCAL_Firmware=${LOCAL_Firmware}
MODEL_type=${BOOT_Type}${Firmware_SFX}
KERNEL_type=${Kernel} - ${LUCI_EDITION}
CURRENT_Device=${CURRENT_Device}
EOF
export LOCAL_Firmware="$(grep 'LOCAL_Firmware=' "/tmp/Version_Tags" | cut -d "-" -f4)"
export CLOUD_Firmware="$(grep 'CLOUD_Firmware=' "/tmp/Version_Tags" | cut -d "-" -f4)"
}

function firmware_Size() {
let CLOUD_Firmware_Size="$(sed -n "${X}p" ${API_PATH} | egrep -o "[0-9]+" | awk '{print ($1)/1048576}' | awk -F. '{print $1}')+1"
if [[ "${TMP_Available}" -lt "${CLOUD_Firmware_Size}" ]]; then
  echo "tmp空间值[${TMP_Available}M],固件体积[${CLOUD_Firmware_Size}M],空间不足" > /tmp/cloud_version
  exit 1
fi
}

function u_firmware() {
if [[ "${LOCAL_Firmware}" -lt "${CLOUD_Firmware}" ]]; then
  echo "检测到有可更新的固件版本,立即更新固件!" > /tmp/cloud_version
else
  exit 0
fi
}

function download_firmware() {
cd "${Download_Path}"
echo "正在下载云端固件,请耐心等待..." > /tmp/cloud_version
if [[ "$(curl -I -s --connect-timeout 8 google.com -w %{http_code} | tail -n1)" == "301" ]]; then
  curl -# -L -O "${Release_download}/${CLOUD_Version}"
  if [[ $? -ne 0 ]];then
    echo "下载固件失败，切换工具继续下载中..." > /tmp/cloud_version
    wget --no-check-certificate --content-disposition -q -T 8 -t 2 "https://ghproxy.com/${Release_download}/${CLOUD_Version}" -O ${CLOUD_Version}
    if [[ $? -ne 0 ]];then
      echo "下载云端固件失败,请检查网络再尝试或手动安装固件!" > /tmp/cloud_version
      echo
      exit 1
    else
      echo "下载云端固件成功!" > /tmp/cloud_version
    fi
  else
    echo "下载云端固件成功!" > /tmp/cloud_version
  fi
else
  curl -# -L -O "https://ghproxy.com/${Release_download}/${CLOUD_Version}"
  if [[ $? -ne 0 ]];then
    echo  "下载固件失败，切换工具继续下载中..." > /tmp/cloud_version
    wget --no-check-certificate --content-disposition -q -T 8 -t 2 "https://pd.zwc365.com/${Release_download}/${CLOUD_Version}" -O ${CLOUD_Version}
    if [[ $? -ne 0 ]];then
      echo  "下载云端固件失败,请检查网络再尝试或手动安装固件!" > /tmp/cloud_version
      echo
      exit 1
    else
      echo  "下载云端固件成功!" > /tmp/cloud_version
    fi
  else
    echo  "下载云端固件成功!" > /tmp/cloud_version
  fi
fi
}

function md5sum_sha256sum() {
export LOCAL_MD5=$(md5sum ${CLOUD_Version} | cut -c1-3)
export LOCAL_256=$(sha256sum ${CLOUD_Version} | cut -c1-3)
export MD5_256=$(echo ${CLOUD_Version} | egrep -o "[a-zA-Z0-9]+${Firmware_SFX}" | sed -r "s/(.*)${Firmware_SFX}/\1/")
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
}

function update_firmware() {
cd "${Download_Path}"
echo "正在执行"${Update_explain}",更新期间请不要断开电源或重启设备 ..." > /tmp/cloud_version
chmod 777 "${CLOUD_Version}"
[[ "$(cat ${PKG_List})" =~ "gzip" ]] && opkg remove gzip > /dev/null 2>&1
sleep 2
  if [[ -f "/etc/deletefile" ]]; then
    chmod 775 "/etc/deletefile"
    source /etc/deletefile
  fi
  curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/common/main/custom/Detectionnetwork > /mnt/Detectionnetwork
  if [[ $? -ne 0 ]]; then
    wget -P /mnt https://raw.githubusercontent.com/281677160/common/main/custom/Detectionnetwork -O /mnt/Detectionnetwork
  fi
  if [[ $? -eq 0 ]]; then
    chmod 775 "/mnt/Detectionnetwork"
    echo "*/5 * * * * source /mnt/Detectionnetwork > /dev/null 2>&1" >> /etc/crontabs/root
  fi
  rm -rf /etc/config/luci
  rm -rf /mnt/back.tar.gz
  sysupgrade -b /mnt/back.tar.gz
  if [[ `ls -1 /mnt | grep -c "back.tar.gz"` -ge '0' ]]; then
    export Upgrade_Options="sysupgrade -q"
  else
    export Upgrade_Options="sysupgrade -f /mnt/back.tar.gz"
  fi

"${Upgrade_Options} ${CLOUD_Version}"
}

function Update() {
lian_wang
api_data
model_name
cloud_Version
record_version
firmware_Size
u_firmware
download_firmware
md5sum_sha256sum
update_firmware
}
Update
