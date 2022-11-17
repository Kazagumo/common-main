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
    print_ok "$1 完成"
    echo
  else
    print_error "$1 失败"
    echo
    exit 1
  fi
}

# 变量
BENDI_VERSION="1.1"
GITHUB_WORKSPACE="$PWD"
GITHUB_ENV="${GITHUB_WORKSPACE}/GITHUB_ENV"
echo '#!/bin/bash' > ${GITHUB_ENV}
sudo chmod +x ${GITHUB_ENV}
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
  exit 1
fi
if [[ `sudo grep -c "NOPASSWD:ALL" /etc/sudoers` == '0' ]]; then
  sudo sed -i 's?%sudo.*?%sudo ALL=(ALL:ALL) NOPASSWD:ALL?g' /etc/sudoers
fi


function Bendi_WslPath() {
if [[ `echo "${PATH}" |grep -c "Windows"` -ge '1' ]]; then
  clear
  ECHOR "您的ubuntu为Windows子系统,是否一次性解决路径问题,还是使用临时路径编译?"
  while :; do
  read -t 30 -p " [输入[Y/y]回车结束编译,按说明解决路径问题,任意键使用临时解决方式](不作处理,30秒自动跳过)： " Bendi_Wsl
  case ${Bendi_Wsl} in
  [Yy])
    ECHOYY "请到 https://github.com/281677160/bendi 查看说明"
    exit 0
  ;;
  *)
    echo "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" >> ${GITHUB_ENV}
    ECHOYY "正在使用临时路径解决编译问题！"
  ;;
  esac
  done
fi
}

function Bendi_Dependent() {
ECHOGG "下载common.sh运行文件"
cd ${GITHUB_WORKSPACE}
curl -L https://raw.githubusercontent.com/281677160/common-main/main/common.sh > common.sh
if [[ $? -ne 0 ]];then
  wget -O common.sh https://raw.githubusercontent.com/281677160/common-main/main/common.sh
fi
if [[ $? -eq 0 ]];then
  sudo chmod +x common.sh
  source common.sh && Diy_update
else
  print_error "common.sh下载失败，请检测网络后再用一键命令试试!"
  exit 1
fi
}

function Bendi_RefreshFile() {
cd ${GITHUB_WORKSPACE}
ECHOGG "将云编译的配置文件修改成本地适用文件"
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
  ECHOR "下载DIY-SETUP自定义配置文件"
  rm -rf DIY-SETUP && svn export https://github.com/281677160/autobuild/trunk/build DIY-SETUP
  judge "DIY-SETUP自定义配置文件下载"
  Bendi_RefreshFile
  judge "将云编译的配置文件修改成本地适用文件"
  source "DIY-SETUP/${FOLDER_NAME}/settings.ini"
else
  source "DIY-SETUP/${FOLDER_NAME}/settings.ini"
fi
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

ECHOGG "是否需要选择机型和增删插件?"
read -t 30 -p " [输入[ Y/y ]回车确认，直接回车则为否](不作处理,30秒自动跳过)： " Bendi_Diy
case ${Bendi_Diy} in
[Yy])
  Menuconfig_Config="true"
  ECHOY "您执行机型和增删插件命令,请耐心等待程序运行至窗口弹出进行机型和插件配置!"
;;
*)
  Menuconfig_Config="false"
  ECHOR "您已关闭选择机型和增删插件设置！"
;;
esac
}

function Bendi_Variable() {
ECHOGG "读取变量"
cd ${GITHUB_WORKSPACE}
source common.sh && Diy_variable
judge "变量读取"
source ${GITHUB_ENV}
}

function Bendi_MainProgram() {
ECHOGG "下载扩展文件"
cd ${GITHUB_WORKSPACE}
source "DIY-SETUP/${FOLDER_NAME}/settings.ini"
rm -rf build && cp -Rf DIY-SETUP build
git clone -b main --depth 1 https://github.com/281677160/common-main build/common
judge "扩展文件下载"
ECHOGG "检测是否缺少文件"
source common.sh && Diy_settings
echo
rm -rf common.sh
mv -f build/common/*.sh build/${FOLDER_NAME}/
sudo chmod -R +x build
}

function Bendi_Download() {
ECHOGG "下载${SOURCE_CODE}-${REPO_BRANCH}源码"
cd ${GITHUB_WORKSPACE}
rm -rf ${HOME_PATH}
git clone -b "${REPO_BRANCH}" --single-branch "${REPO_URL}" ${HOME_PATH}
judge "源码下载"
source ${GITHUB_WORKSPACE}/build/${FOLDER_NAME}/common.sh && Diy_checkout
mv -f ${GITHUB_WORKSPACE}/build ${HOME_PATH}/build
}

function Bendi_SourceClean() {
ECHOGG "源码微调"
cd ${HOME_PATH}
source ${GITHUB_ENV}
source ${BUILD_PATH}/common.sh && Diy_menu3
judge "源码微调"
}

function Bendi_UpdateSource() {
ECHOGG "读取自定义文件"
cd ${HOME_PATH}
source ${BUILD_PATH}/$DIY_PART_SH
source ${BUILD_PATH}/common.sh && Diy_Publicarea
judge "读取自定义文件"
ECHOGG "加载files,语言,更新源"
source ${BUILD_PATH}/common.sh && Diy_menu4
judge "加载files,语言,更新源"
}

function Bendi_Menuconfig() {
cd ${HOME_PATH}
if [[ "${Menuconfig_Config}" == "true" ]]; then
  ECHOGG "配置机型，插件等..."
  make menuconfig
  if [[ $? -ne 0 ]]; then
    ECHOY "SSH工具窗口分辨率太小，无法弹出设置机型或插件的窗口"
    ECHOG "请调整SSH工具窗口分辨率后按[Y/y]继续,或者按[N/n]退出编译"
    XUANMA="请输入您的选择"
    while :; do
    read -p " ${XUANMA}：" Bendi_Menu
    case ${Bendi_Menu} in
    [Yy])
      Bendi_Menuconfig
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
ECHOGG "检测配置,生成配置"
cd ${HOME_PATH}
source ${GITHUB_ENV}
source ${BUILD_PATH}/common.sh && Diy_menu5
judge "检测配置,生成配置"
}

function Bendi_ErrorMessage() {
cd ${HOME_PATH}
source ${GITHUB_ENV}
if [[ -s "${HOME_PATH}/CHONGTU" ]]; then
  echo
  TIME b "		错误提示"
  echo
  sudo chmod +x ${HOME_PATH}/CHONGTU
  source ${HOME_PATH}/CHONGTU
  echo
  read -t 30 -p " [如需重新编译请输入[ Y/y ]按回车，任意键则为继续编译](不作处理话,30后秒继续编译)： " Bendi_Error
  case ${Bendi_Error} in
  [Yy])
     sleep 2
     exit 1
  ;;
  *)
    ECHOG "继续编译中...！"
  ;;
  esac
fi
rm -rf ${HOME_PATH}/CHONGTU
}

function Bendi_DownloadDLFile() {
ECHOGG "下载DL文件，请耐心等候..."
cd ${HOME_PATH}
make defconfig
make -j8 download |tee ${HOME_PATH}/build.log
if [[ `grep -c "make with -j1 V=s or V=sc" ${HOME_PATH}/build.log` -eq '0' ]] || [[ `grep -c "ERROR" ${HOME_PATH}/build.log` -eq '0' ]]; then
  print_ok "DL文件下载成功"
else
  clear
  echo
  print_error "下载DL失败，更换节点后再尝试下载？"
  QLMEUN="请更换节点后按[Y/y]回车继续尝试下载DL，或输入[N/n]回车,退出编译"
  while :; do
    read -p " [${QLMEUN}]： " Bendi_DownloadDL
    case ${Bendi_DownloadDL} in
  [Yy])
    Bendi_DownloadDLFile
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
source ${GITHUB_ENV}
export Model_Name="$(cat /proc/cpuinfo |grep 'model name' |awk 'END {print}' |cut -f2 -d: |sed 's/^[ ]*//g')"
export Cpu_Cores="$(cat /proc/cpuinfo | grep 'cpu cores' |awk 'END {print}' | cut -f2 -d: | sed 's/^[ ]*//g')"
export RAM_total="$(free -h |awk 'NR==2' |awk '{print $(2)}' |sed 's/.$//')"
export RAM_available="$(free -h |awk 'NR==2' |awk '{print $(7)}' |sed 's/.$//')"
echo
ECHOGG "您现在编译所用的服务器CPU型号为[ ${Model_Name} ]"
ECHOGG "在此ubuntu分配核心数为[ ${Cpu_Cores} ],线程数为[ $(nproc) ]"
ECHOGG "在此ubuntu分配内存为[ ${RAM_total} ],现剩余内存为[ ${RAM_available} ]"

[[ -d "${FIRMWARE_PATH}" ]] && rm -rf ${FIRMWARE_PATH}/*
if [[ "$(nproc)" -le "12" ]];then
  ECHOYY "即将使用$(nproc)线程进行编译固件"
  sleep 8
  if [[ `echo "${PATH}" |grep -c "Windows"` -ge '1' ]]; then
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make V=s -j$(nproc) |tee ${HOME_PATH}/build.log
  else
     make V=s -j$(nproc) |tee ${HOME_PATH}/build.log
  fi
else
  ECHOGG "您的CPU线程超过或等于16线程，强制使用16线程进行编译固件"
  sleep 8
  if [[ `echo "${PATH}" |grep -c "Windows"` -ge '1' ]]; then
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make V=s -j16 |tee ${HOME_PATH}/build.log
  else
     make V=s -16 |tee ${HOME_PATH}/build.log
  fi
fi

if [[ `ls -1 "${FIRMWARE_PATH}" | grep -c "immortalwrt"` -ge '1' ]]; then
  rename -v "s/^immortalwrt/openwrt/" ${FIRMWARE_PATH}/*
fi

if [[ `ls -1 "${FIRMWARE_PATH}" |grep -c "openwrt"` -eq '0' ]]; then
  print_error "编译失败~~!"
  exit 1
else
  cp -Rf ${FIRMWARE_PATH}/config.buildinfo ${GITHUB_WORKSPACE}/DIY-SETUP/${FOLDER_NAME}/${CONFIG_FILE}
  print_ok "编译固件成功"
  print_ok "已经为您把配置文件替换到DIY-SETUP/${FOLDER_NAME}/${CONFIG_FILE}上"
fi
}

function Bendi_Arrangement() {
ECHOGG "整理固件"
cd ${HOME_PATH}
source ${GITHUB_ENV}
source ${BUILD_PATH}/common.sh && Diy_firmware
judge "整理固件"
}


function Bendi_menu2() {
FOLDER_NAME="Official"
Bendi_WslPath
Bendi_Dependent
Bendi_DiySetup
Bendi_EveryInquiry
Bendi_Variable
Bendi_MainProgram
rm -rf ${HOME_PATH}/build
mv -f ${GITHUB_WORKSPACE}/build ${HOME_PATH}/build
sed -i '/-rl/d' "${BUILD_PATH}/${DIY_PART_SH}"
Bendi_UpdateSource
Bendi_Menuconfig
Bendi_Configuration
Bendi_ErrorMessage
Bendi_DownloadDLFile
Bendi_Compile
Bendi_Arrangement
}

function Bendi_menu() {
FOLDER_NAME="Official"
Bendi_WslPath
Bendi_Dependent
Bendi_DiySetup
Bendi_EveryInquiry
Bendi_Variable
Bendi_MainProgram
Bendi_Download
Bendi_SourceClean
Bendi_UpdateSource
Bendi_Menuconfig
Bendi_Configuration
Bendi_ErrorMessage
Bendi_DownloadDLFile
Bendi_Compile
Bendi_Arrangement
}
Bendi_menu2 "$@"
