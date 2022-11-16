#!/bin/bash

#====================================================
#	System Request:Ubuntu 18.04+/20.04+
#	Author:	281677160
#	Dscription: openwrt onekey Management
#	github: https://github.com/281677160
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
function ECHOY() {
  echo
  echo -e "${Yellow} $1 ${Font}"
  echo
}
function ECHOG() {
  echo
  echo -e "${Green} $1 ${Font}"
  echo
}
function ECHOB() {
  echo
  echo -e "${Blue} $1 ${Font}"
  echo
}
  function ECHOR() {
  echo
  echo -e "${Red} $1 ${Font}"
  echo
}
function ECHOYY() {
  echo -e "${Yellow} $1 ${Font}"
}
function ECHOGG() {
  echo -e "${Green} $1 ${Font}"
}
  function ECHORR() {
  echo -e "${Red} $1 ${Font}"
}
judge() {
  if [[ 0 -eq $? ]]; then
    echo
    print_ok "$1 完成"
    echo
    sleep 1
  else
    echo
    print_error "$1 失败"
    echo
    exit 1
  fi
}

# 变量
export BENDI_VERSION="1.1"
export GITHUB_WORKSPACE="$PWD"
export GITHUB_ENV="${GITHUB_WORKSPACE}/GITHUB_ENV"
echo '#!/bin/bash' > ${GITHUB_ENV}
chmod +x ${GITHUB_ENV}
source /etc/os-release
case "${UBUNTU_CODENAME}" in
"bionic"|"focal"|"jammy")
  echo "${PRETTY_NAME}"
;;
*)
  print_error "请使用Ubuntu 64位系统，推荐 Ubuntu 20.04 LTS 或 Ubuntu 22.04 LTS"
exit 1
;;
esac
if [[ "$USER" == "root" ]]; then
  print_error "警告：请勿使用root用户编译，换一个普通用户吧~~"
  exit 1
fi
Google_Check=$(curl -I -s --connect-timeout 8 google.com -w %{http_code} | tail -n1)
if [ ! "$Google_Check" == 301 ];then
  print_error "提醒：编译之前请自备梯子，编译全程都需要稳定翻墙的梯子~~"
  exit 0
fi
if [[ `sudo grep -c "NOPASSWD:ALL" /etc/sudoers` == '0' ]]; then
  sudo sed -i 's?%sudo.*?%sudo ALL=(ALL:ALL) NOPASSWD:ALL?g' /etc/sudoers
fi


function Bendi_Dependent() {
source ${GITHUB_WORKSPACE}/build/${FOLDER_NAME}/common.sh && Diy_update
}

function Bendi_RefreshFile() {
cd ${GITHUB_WORKSPACE}
rm -rf ${GITHUB_WORKSPACE}/DIY-SETUP/*/start-up
for X in $(find ${GITHUB_WORKSPACE}/DIY-SETUP -name ".config" |sed 's/\/.config//g'); do 
  mv "${X}/.config" "${X}/config"
  mkdir -p "${X}/version"
  echo "BENDI_VERSION=${BENDI_VERSION}" > "${X}/version/bendi_version"
  echo "bendi_version文件为检测版本用,请勿修改和删除" > "${X}/version/README.md"
done
for X in $(find ${GITHUB_WORKSPACE}/DIY-SETUP -name "settings.ini"); do
  sed -i 's/.config/config/g' "${X}"
  sed -i '/SSH_ACTIONS/d' "${X}"
  sed -i '/UPLOAD_CONFIG/d' "${X}"
  sed -i '/UPLOAD_FIRMWARE/d' "${X}"
  sed -i '/UPLOAD_WETRANSFER/d' "${X}"
  sed -i '/UPLOAD_RELEASE/d' "${X}"
  sed -i '/INFORMATION_NOTICE/d' "${X}"
  sed -i '/CACHEWRTBUILD_SWITCH/d' "${X}"
  sed -i '/COMPILATION_INFORMATION/d' "${X}"
  sed -i '/UPDATE_FIRMWARE_ONLINE/d' "${X}"
  echo 'MODIFY_CONFIGURATION="true"            # 是否每次都询问您要不要去设置自定义文件（true=开启）（false=关闭）' >> "${X}"
done
}

function Bendi_DiySetup() {
cd ${GITHUB_WORKSPACE}
if [ ! -f "DIY-SETUP/${FOLDER_NAME}/settings.ini" ]; then
  ECHOR "缺少DIY-SETUP自定义配置文件,正在下载中..."
  rm -rf DIY-SETUP && svn export https://github.com/281677160/autobuild/trunk/build DIY-SETUP
  Bendi_RefreshFile
  source "DIY-SETUP/${FOLDER_NAME}/settings.ini"
else
  source "DIY-SETUP/${FOLDER_NAME}/settings.ini"
fi
}

function Bendi_Variable() {
echo "读取变量"
curl -L https://raw.githubusercontent.com/281677160/common-main/main/common.sh > common.sh
if [[ $? -ne 0 ]];then
  wget -O common.sh https://raw.githubusercontent.com/281677160/common-main/main/common.sh
fi
if [[ $? -eq 0 ]];then
  sudo chmod +x common.sh
  source common.sh && Diy_variable
  sudo rm -rf common.sh
else
  ECHOR "common.sh下载失败，请检测网络后再用一键命令试试!"
  exit 1
fi
source ${GITHUB_ENV}
}

function Bendi_EveryInquiry() {
if [[ "${MODIFY_CONFIGURATION}" == "true" ]]; then
  clear
  echo
  echo
  ECHOYY "请在 DIY-SETUP/${FOLDER_NAME} 里面设置好自定义文件"
  ECHOY "设置完毕后，按[W/w]回车继续编译"
  ZDYSZ="请输入您的选择"
  while :; do
  read -p " ${ZDYSZ}： " ZDYSZU
  case $ZDYSZU in
  [Ww])
    echo
  break
  ;;
  *)
    ZDYSZ="提醒：确认设置完毕后，请按[W/w]回车继续编译"
  ;;
  esac
  done
fi
}

function Bendi_MainProgram() {
echo "下载编译文件"
cd ${GITHUB_WORKSPACE}
cp -Rf DIY-SETUP build
git clone -b main --depth 1 https://github.com/281677160/common-main build/common
mv -f build/common/*.sh build/${FOLDER_NAME}/
sudo chmod -R +x build
}

function Bendi_Download() {
echo "下载源码中,请稍后"
rm -rf ${HOME_PATH}
git clone -b "${REPO_BRANCH}" --single-branch "${REPO_URL}" ${HOME_PATH}
source ${GITHUB_WORKSPACE}/build/${FOLDER_NAME}/common.sh && Diy_checkout
mv -f ${GITHUB_WORKSPACE}/build ${HOME_PATH}/build
}

function Bendi_UpdateSource() {
echo "正在更新源和读取自定义文件,请稍后"
cd ${HOME_PATH}
source ${BUILD_PATH}/common.sh && Diy_menu3
source $BUILD_PATH/$DIY_PART_SH
source build/${FOLDER_NAME}/common.sh && Diy_Publicarea
source ${BUILD_PATH}/common.sh && Diy_menu4
}

function Bendi_Menuconfig() {
cd ${HOME_PATH}
if [[ "${Menuconfig}" == "true" ]]; then
  echo "配置机型，插件等..."
  make menuconfig
  if [[ $? -ne 0 ]]; then
    ECHOY "SSH工具窗口分辨率太小，无法弹出设置机型或插件的窗口"
    ECHOG "请调整SSH工具窗口分辨率后按[Y/y]继续,或者按[N/n]退出编译"
    XUANMA="请输入您的选择"
    while :; do
    read -p " ${XUANMA}：" Make
    case $Make in
    [Yy])
	    op_menuconfig
	  break
    ;;
    [Nn])
	    exit 1
	  break
    ;;
    *)
      XUANMA="输入错误,请输入[Y/n]"
    ;;
    esac
    done
  fi
fi
}

function Bendi_Configuration() {
echo "确认固件配置"
cd ${HOME_PATH}
source ${BUILD_PATH}/common.sh && Diy_menu5
}

function Bendi_ErrorMessage() {
cd ${HOME_PATH}
if [[ -s "${HOME_PATH}/CHONGTU" ]]; then
  echo
  TIME b "			错误信息"
  echo
  chmod -R +x ${HOME_PATH}/CHONGTU
  source ${HOME_PATH}/CHONGTU
  echo
  read -t 30 -p " [如需重新编译请按输入[ Y/y ]回车确认，直接回车则为否](不作处理话,30秒自动跳过)： " CTCL
  case $CTCL in
  [Yy])
     rm -rf ${HOME_PATH}/CHONGTU
     sleep 2
     exit 1
  ;;
  *)
    rm -rf ${HOME_PATH}/CHONGTU
    ECHOG "继续编译中...！"
  ;;
  esac
fi
}

function Bendi_DownloadDLFile() {
ECHOG "下载DL文件，请耐心等候..."
cd ${HOME_PATH}
make -j8 download |tee ${HOME_PATH}/build.log
find dl -size -1024c -exec ls -l {} \;
find dl -size -1024c -exec rm -f {} \;
if [[ `grep -c "make with -j1 V=s or V=sc" ${HOME_PATH}/build.log` -eq '0' ]] || [[ `grep -c "ERROR" ${HOME_PATH}/build.log` -eq '0' ]]; then
  print_ok "DL文件下载成功"
else
  clear
  echo
  print_error "下载DL失败，更换节点后再尝试下载？"
  QLMEUN="请更换节点后按[Y/y]回车继续尝试下载DL，或输入[N/n]回车,退出编译"
  while :; do
    read -p " [${QLMEUN}]： " XZDLE
    case $XZDLE in
  [Yy])
    op_download
  break
  ;;
  [Nn])
    ECHOR "退出编译程序!"
    sleep 1
    exit 1
   break
   ;;
   *)
     QLMEUN="请更换节点后按[Y/y]回车继续尝试下载DL，或现在输入[N/n]回车,退出编译"
   ;;
   esac
   done
fi
}

function Bendi_Compile() {
cd ${HOME_PATH}
make V=s -j$(nproc)
}

function Bendi_Arrangement() {
cd ${HOME_PATH}
source ${BUILD_PATH}/common.sh && Diy_firmware
}

function Bendi_menu() {
FOLDER_NAME="Official"
Bendi_Dependent
Bendi_DiySetup
Bendi_Variable
Bendi_EveryInquiry
Bendi_MainProgram
Bendi_Download
Bendi_UpdateSource
Bendi_Menuconfig
Bendi_Configuration
Bendi_ErrorMessage
Bendi_DownloadDLFile
Bendi_Compile
Bendi_Arrangement
}
Bendi_menu "$@"
