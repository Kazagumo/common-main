#!/bin/sh

#====================================================
#	Author:	281677160
#	Dscription: openwrt onekey Management
#	github: https://github.com/281677160/build-actions
#====================================================

# 字体颜色配置
Green="\033[32m"
Red="\033[31m"
Yellow="\033[33m"
Blue="\033[36m"
Font="\033[0m"
GreenBG="\033[1;36m"
RedBG="\033[41;37m"
OK="${Green}[OK]${Font}"
GX=" ${Red}[恭喜]${Font}"
ERROR="${Red}[ERROR]${Font}"

function ECHOY() {
  echo
  echo -e "${Yellow} $1 ${Font}"
  echo
}
function ECHOR() {
  echo -e "${Red} $1 ${Font}"
}
function ECHOB() {
  echo
  echo -e "${Blue} $1 ${Font}"
}
function ECHOBG() {
  echo
  echo -e "${GreenBG} $1 ${Font}"
}
function ECHOYY() {
  echo -e "${Yellow} $1 ${Font}"
}
function ECHOG() {
  echo -e "${Green} $1 ${Font}"
  echo
}
function print_ok() {
  echo
  echo -e " ${OK} ${Blue} $1 ${Font}"
  echo
}
function print_error() {
  echo
  echo -e "${ERROR} ${RedBG} $1 ${Font}"
  echo
}
function print_gg() {
  echo
  echo -e "${GX}${Green} $1 ${Font}"
  echo
}

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
  CURRENT_Device=$(jsonfilter -e '@.model.id' < /etc/board.json | tr ',' '_')
  BOOT_Type=sysupgrade
esac

7.01-Lienol-x86-64-202211210153-legacy-eab838.img.gz
36.1 MB
3 days ago
18.06-Immortalwrt-x86-64-202211210155-legacy-82541b.img.gz
21.9 MB
3 days ago
18.06-Immortalwrt-x86-64-202211210155-uefi-d40397.img.gz
22.1 MB
3 days ago
18.06-Lede-x86-64-202211210156-legacy-81128a.img.gz
54.5 MB
3 days ago
18.06-Lede-x86-64-202211210156-uefi-219310.img.gz
54.7 MB
3 days ago
18.06-Lede-x86-64-202211221901-legacy-c22527.img.gz
54.8 MB
23 hours ago
18.06-Lede-x86-64-202211221901-uefi-365cc6.img.gz
54.9 MB
23 hours ago
18.06-Lede-x86-64-202211230100-legacy-4a4109.img.gz
54.6 MB
17 hours ago
18.06-Lede-x86-64-202211230100-uefi-d890fb.img.gz
54.8 MB
17 hours ago
19.07-Official-x86-64-202211210155-legacy-3d7260.img.gz


CLOUD_Firmware_1="$(egrep -o "18.06-Lede-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"

CLOUD_Firmware_2="$(egrep -o "17.01-Lienol-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_3="$(egrep -o "19.07-Lienol-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_4="$(egrep -o "21.02-Lienol-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_5="$(egrep -o "master-Lienol-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"


CLOUD_Firmware_6="$(egrep -o "18.06-Immortalwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_7="$(egrep -o "18.06-K54-Immortalwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_8="$(egrep -o "21.02-Immortalwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_9="$(egrep -o "master-Immortalwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"

CLOUD_Firmware_10="$(egrep -o "19.07-Official-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_11="$(egrep -o "21.02-Official-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_12="$(egrep -o "22.03-Official-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_13="$(egrep -o "master-Official-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"


CLOUD_Firmware_14="$(egrep -o "21.02-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_15="$(egrep -o "22.03-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_16="$(egrep -o "master-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"

CLOUD_Firmware_17="$(egrep -o "ap-x-wrt-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_18="$(egrep -o "fix-arm-trusted-firmware-mediatek-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_19="$(egrep -o "fix-busybox-nslookup-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_20="$(egrep -o "fix-hostapd-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_21="$(egrep -o "fix-kdump-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_22="$(egrep -o "fix-lzma-openwrt-magic-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_23="$(egrep -o "fix-mac-address-increment-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_24="$(egrep -o "fix-missing-symbol-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_25="$(egrep -o "fix-mmap-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_26="$(egrep -o "fix-mt7663-firmware-sta-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_27="$(egrep -o "fix-nand_do_platform_check-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_28="$(egrep -o "fix-nand_upgrade_ubinized-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_29="$(egrep -o "fix-okli-loader-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_30="$(egrep -o "fix-uboot-mediatek-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_31="$(egrep -o "fix-uboot-mediatek-erase-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_32="$(egrep -o "fix-umdns-filter-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_33="$(egrep -o "ipvlan-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_34="$(egrep -o "mt7621-gsw150-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_35="$(egrep -o "mtk_ppe-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_36="$(egrep -o "p910nd-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_37="$(egrep -o "pr-dnsmasq-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_38="$(egrep -o "pr-fix-nand_do_platform_check-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_39="$(egrep -o "pr-ipq40xx-rt-ac42u-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_40="$(egrep -o "pr-rm-ax6000-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_41="$(egrep -o "switch_ports_status-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
CLOUD_Firmware_42="$(egrep -o "switch-Xwrt-${DEFAULT_Device}-[0-9]+-${BOOT_Type}-[a-zA-Z0-9]+${Firmware_SFX}" ${API_PATH} | awk 'END {print}')"
















