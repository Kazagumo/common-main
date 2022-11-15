#!/bin/sh

#====================================================
#	MANUFACTURER:	281677160
#	Dscription: openwrt onekey Management
#	github: https://github.com/281677160/build-actions
#====================================================

# 字体颜色配置
Green="\033[32m"
Red="\033[31m"
Yellow="\033[33m"
Blue="\033[36m"
Font="\033[0m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
OK="${Green}[OK]${Font}"
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
  echo
}
function ECHOYY() {
  echo -e "${Yellow} $1 ${Font}"
}
function ECHOG() {
  echo
  echo -e "${Green} $1 ${Font}"
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
judge() {
  if [[ 0 -eq $? ]]; then
    print_ok "$1 完成,3秒后重启系统"
    sleep 2
    reboot -f
  else
    print_error "$1 失败"
  fi
}

function xiugai_ip() {
  echo
  echo
  ipadd="$(grep "ipaddr" "/etc/config/network" | grep -v 127.0.0.1 |egrep -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
  ECHOG "您当前使用IP为：${ipadd}"
  echo
  export YUMING="请输入您想要更改成的后台IP"
  echo
  while :; do
  domainy=""
  read -p " ${YUMING}：" domain
  if [[ -n "${domain}" ]] && [[ "$(echo ${domain} |egrep -c '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')" == '1' ]]; then
    domainy="Y"
  fi
  case $domainy in
  Y)
    export domain="${domain}"
    uci set network.lan.ipaddr="${domain}"
    uci commit network
    ECHOG "您的IP为：${domain}"
    ECHOY "正在为您清空密码"
    passwd -d root
    judge
  break
  ;;
  *)
    export YUMING="敬告：请输入正确格式的IP"
  ;;
  esac
  done
}

function qingkong_mima() {
while :; do
read -p 请输入[Y/n]选择是否清空密码： YN
case ${YN} in
[Yy]) 
    passwd -d root
    judge
break
;;
[Nn])
    ECHOR "您已跳过清空密码"
break
;;
*)
    ECHOR ""
;;
esac
done
}

function first_boot() {
  echo
  echo
  ECHOR "是否恢复出厂设置?按[Y/y]执行,按[N/n]退出"
  firstboot
  judge
}

menu() {
  clear
  echo  
  ECHOB "  请选择执行命令编码"
  ECHOYY " 1. 修改后台IP和清空密码"
  ECHOY " 2. 清空密码(Clear password)"
  ECHOYY " 3. 恢复出厂设置(Restore factory settings)"
  ECHOY " 4. 退出菜单(EXIT)"
  echo
  XUANZHEOP="请输入数字"
  while :; do
  read -p " ${XUANZHEOP}： " CHOOSE
  case $CHOOSE in
    1)
      xiugai_ip
    break
    ;;
    2)
      qingkong_mima
    break
    ;;
    3)
      first_boot
    break
    ;;
    4)
      ECHOR "您选择了退出程序"
      exit 0
    break
    ;;
    *)
      XUANZHEOP="请输入正确的数字编号!"
    ;;
    esac
    done
}

menu "$@"

exit 0
