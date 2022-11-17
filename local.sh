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
HOME_PATH="${GITHUB_WORKSPACE}/openwrt"
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
if [[ `sudo grep -c "sudo ALL=(ALL:ALL) NOPASSWD:ALL" /etc/sudoers` == '0' ]]; then
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
read -t 30 -p " [输入[ Y/y ]回车确认，任意键则为否](不作处理,30秒自动跳过)： " Bendi_Diy
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
[[ -f "${DEFAULT_PATH}" ]] && source common.sh && Diy_wenjian
echo
mv -f build/common/*.sh build/${FOLDER_NAME}/
sudo chmod -R +x build
}

function Bendi_Download() {
ECHOGG "下载${SOURCE_CODE}-${REPO_BRANCH}源码"
cd ${GITHUB_WORKSPACE}
rm -rf ${HOME_PATH}
git clone -b "${REPO_BRANCH}" --single-branch "${REPO_URL}" ${HOME_PATH}
judge "源码下载"
if [[ -d "${GITHUB_WORKSPACE}/build" ]]; then
  cd ${HOME_PATH}
  source ${GITHUB_WORKSPACE}/build/${FOLDER_NAME}/common.sh && Diy_checkout
  mv -f ${GITHUB_WORKSPACE}/build ${HOME_PATH}/build
else
  cd ${HOME_PATH}
  source common.sh && Diy_checkout
fi
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
[[ -f "${GITHUB_WORKSPACE}/common.sh" ]] && rm -rf ${GITHUB_WORKSPACE}/common.sh

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
  ECHOGG "在 openwrt/build.log 可查看编译日志,日志文件比较大,拖动到电脑查看比较方便"
  exit 1
else
  cp -Rf ${FIRMWARE_PATH}/config.buildinfo ${GITHUB_WORKSPACE}/DIY-SETUP/${FOLDER_NAME}/${CONFIG_FILE}
  echo "
  FOLDER_NAME2="${FOLDER_NAME}"
  REPO_BRANCH2="${REPO_BRANCH}"
  TARGET_PROFILE2="${TARGET_PROFILE}"
  " > ${HOME_PATH}/diysetup
  sed -i 's/^[ ]*//g' ${HOME_PATH}/diysetup
  sudo chmod +x ${HOME_PATH}/diysetup
  print_ok "编译固件成功"
  print_ok "已为您把配置文件替换到DIY-SETUP/${FOLDER_NAME}/${CONFIG_FILE}里"
fi
}

function Bendi_Arrangement() {
ECHOGG "整理固件"
cd ${HOME_PATH}
source ${GITHUB_ENV}
source ${BUILD_PATH}/common.sh && Diy_firmware
judge "整理固件"
}

function Bendi_Packaging() {
  cd ${GITHUB_WORKSPACE}
  if [[ `ls -1 "${HOME_PATH}/bin/targets/armvirt/64" | grep -c "tar.gz"` == '0' ]]; then
    mkdir -p "${HOME_PATH}/bin/targets/armvirt/64"
    clear
    echo
    echo
    ECHOR "没发现 openwrt/bin/targets/armvirt/64 文件夹里存在.tar.gz固件，已为你创建了文件夹"
    ECHORR "请用WinSCP工具将\"openwrt-armvirt-64-default-rootfs.tar.gz\"固件存入文件夹中"
    ECHOY "提醒：Windows的WSL系统的话，千万别直接打开文件夹来存放固件，很容易出错的，要用WinSCP工具或SSH工具自带的文件管理器"
    echo
    exit 1
  fi
  if [[ -d "${GITHUB_WORKSPACE}/amlogic" ]]; then
    if [[ `sudo grep -c "sudo ALL=(ALL:ALL) NOPASSWD:ALL" /etc/sudoers` == '0' ]]; then
      sudo sed -i 's?%sudo.*?%sudo ALL=(ALL:ALL) NOPASSWD:ALL?g' /etc/sudoers
    fi
    clear
    echo
    sudo rm -rf "${GITHUB_WORKSPACE}/amlogic"
    if [[ -d "${GITHUB_WORKSPACE}/amlogic" ]]; then
      ECHOR "已存在的amlogic文件夹无法删除，请重启系统再来尝试"
      exit 1
    fi
    ECHOY "正在下载打包所需的程序,请耐心等候~~~"
    git clone --depth 1 https://github.com/ophub/amlogic-s9xxx-openwrt.git ${GITHUB_WORKSPACE}/amlogic
    judge "内核运行文件下载"
    rm -rf ${GITHUB_WORKSPACE}/amlogic/{router-config,LICENSE,README.cn.md,README.md,.github,.git}
  else
    ECHOY "正在下载打包所需的程序,请耐心等候~~~"
    git clone --depth 1 https://github.com/ophub/amlogic-s9xxx-openwrt.git ${GITHUB_WORKSPACE}/amlogic
    judge "内核运行文件下载"
    rm -rf ${GITHUB_WORKSPACE}/amlogic/{router-config,LICENSE,README.cn.md,README.md,.github,.git}
  fi
  [[ -z "${FIRMWARE_PATH}" ]] && export FIRMWARE_PATH="${HOME_PATH}/bin/targets/armvirt/64"
  [ ! -d ${GITHUB_WORKSPACE}/amlogic/openwrt-armvirt ] && mkdir -p ${GITHUB_WORKSPACE}/amlogic/openwrt-armvirt
  ECHOY "全部可打包机型：s922x s922x-n2 s922x-reva a311d s905x3 s905x2 s905x2-km3 s905l3a s912 s912-m8s s905d s905d-ki s905x s905w s905"
  ECHOGG "设置要打包固件的机型[ 直接回车则默认全部机型(all) ]"
  read -p " 请输入您要设置的机型：" amlogic_model
  export amlogic_model=${amlogic_model:-"all"}
  ECHOYY "您设置的机型为：${amlogic_model}"
  echo
  ECHOGG "设置打包的内核版本[直接回车则默认 5.15.xx 和 5.10.xx ，xx为当前最新版本]"
  read -p " 请输入您要设置的内核：" amlogic_kernel
  export amlogic_kernel=${amlogic_kernel:-"5.15.25_5.10.100 -a true"}
  if [[ "${amlogic_kernel}" == "5.15.25_5.10.100 -a true" ]]; then
    ECHOYY "您设置的内核版本为：5.15.xx 和 5.10.xx "
  else
    ECHOYY "您设置的内核版本为：${amlogic_kernel}"
  fi
  echo
  ECHOGG "设置ROOTFS分区大小[ 直接回车则默认：960 ]"
  read -p " 请输入ROOTFS分区大小：" rootfs_size
  export rootfs_size=${rootfs_size:-"960"}
  ECHOYY "您设置的ROOTFS分区大小为：${rootfs_size}"
  if [[ `ls -1 "${FIRMWARE_PATH}" |grep -c ".*default-rootfs.tar.gz"` == '1' ]]; then
    cp -Rf ${FIRMWARE_PATH}/*default-rootfs.tar.gz ${GITHUB_WORKSPACE}/amlogic/openwrt-armvirt/openwrt-armvirt-64-default-rootfs.tar.gz && sync
  else
    armvirtargz="$(ls -1 "${FIRMWARE_PATH}" |grep ".*tar.gz" |awk 'END {print}')"
    cp -Rf ${FIRMWARE_PATH}/${armvirtargz} ${GITHUB_WORKSPACE}/amlogic/openwrt-armvirt/openwrt-armvirt-64-default-rootfs.tar.gz && sync
  fi
  if [[ `ls -1 "${GITHUB_WORKSPACE}/amlogic/openwrt-armvirt" | grep -c "openwrt-armvirt-64-default-rootfs.tar.gz"` == '0' ]]; then
    print_error "amlogic/openwrt-armvirt文件夹没发现openwrt-armvirt-64-default-rootfs.tar.gz固件存在"
    print_error "请检查${HOME_PATH}/bin/targets/armvirt/64文件夹内有没有openwrt-armvirt-64-default-rootfs.tar.gz固件存在"
    exit 1
  fi
  cd ${GITHUB_WORKSPACE}/amlogic
  sudo chmod +x make
  sudo ./make -d -b ${amlogic_model} -k ${amlogic_kernel} -s ${rootfs_size}
  if [[ `ls -1 ${GITHUB_WORKSPACE}/amlogic/out | grep -c "openwrt"` -ge '1' ]]; then
    print_ok "打包完成，固件存放在[amlogic/out]文件夹"
    if [[ "${WSL_ubuntu}" == "YES" ]]; then
      cd ${GITHUB_WORKSPACE}/amlogic/out
      explorer.exe .
      cd ${GITHUB_WORKSPACE}
    fi
  else
    print_error "打包失败，请再次尝试!"
  fi
}

function Bendi_Change() {
cd ${HOME_PATH}
if [[ ! "${REPO_BRANCH2}" == "${REPO_BRANCH}" ]]; then
  ECHOR "编译分支发生改变,需要重新下载源码,下载源码中..."
  sleep 5
  Bendi_Download
elif [[ ! "${COLLECTED_PACKAGES}" == "true" ]]; then
  if [[ `grep -c "danshui" feeds.conf.default` -ge '1' ]]; then
    ECHOR "您的自定义设置更改为不需要作者收集的插件包,正在清理插件中..."
    sleep 5
    sed -i '/danshui/d' feeds.conf.default
    sed -i '/helloworld/d' feeds.conf.default
    sed -i '/passwall/d' feeds.conf.default
    ./scripts/feeds clean
    ./scripts/feeds update -a
  fi
elif [[ "${COLLECTED_PACKAGES}" == "true" ]]; then
  if [[ `grep -c "danshui" feeds.conf.default` -eq '0' ]]; then
    ECHOG "您的自定义设置更改为需要作者收集的插件包,正在增加插件中..."
    sleep 5
    sed -i '/danshui/d' feeds.conf.default
    sed -i '/helloworld/d' feeds.conf.default
    sed -i '/fw876/d' feeds.conf.default
    sed -i '/passwall/d' feeds.conf.default
    sed -i '/xiaorouji/d' feeds.conf.default
    ./scripts/feeds clean
    ./scripts/feeds update -a
    source ${GITHUB_WORKSPACE}/common.sh && Diy_${SOURCE_CODE}
    source ${GITHUB_WORKSPACE}/common.sh && Diy_chajianyuan
  fi
fi
}

function Bendi_Restore() {
rm -rf ${HOME_PATH}/build
mv -f ${GITHUB_WORKSPACE}/build ${HOME_PATH}/build
sed -i '/-rl/d' "${BUILD_PATH}/${DIY_PART_SH}"
}

function Bendi_menu2() {
FOLDER_NAME="${FOLDER_NAME2}"
Bendi_WslPath
Bendi_Dependent
Bendi_DiySetup
Bendi_EveryInquiry
Bendi_Variable
Bendi_Change
Bendi_MainProgram
Bendi_Restore
Bendi_UpdateSource
Bendi_Menuconfig
Bendi_Configuration
Bendi_ErrorMessage
Bendi_DownloadDLFile
Bendi_Compile
Bendi_Arrangement
}

function Bendi_menu() {
FOLDER_NAME="${FOLDER_NAME3}"
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

function Bendi_xuanzhe() {
  cd ${GITHUB_WORKSPACE}
  if [[ ! -d "DIY-SETUP" ]]; then
    echo "没有主要编译程序存在,正在下载中,请稍后..."
    Bendi_DiySetup
  else
    YY="$(ls -1 "DIY-SETUP")"
    if [[ -z "${YY}" ]]; then
      echo "没有主要编译程序存在,正在下载中,请稍后..."
      Bendi_DiySetup
    fi
  fi
  clear
  echo 
  echo
  ls -1 "DIY-SETUP" |awk '$0=NR" "$0' |tee GITHUB_ENV
  XYZDSZ="$(cat GITHUB_ENV | awk 'END {print}' |awk '{print $(1)}')"
  echo
  echo
  echo -e "${Blue}请输入您要编译的源码，选择前面对应的数值,输入[0]为退出程序${Font}"
  echo
  export YUMINGIP="请输入前面对应的数值"
  while :; do
  YMXZ=""
  read -p "${YUMINGIP}：" YMXZ
  if [[ "${YMXZ}" == "0" ]]; then
    CUrrenty="N"
  elif [[ "${YMXZ}" -le "${XYZDSZ}" ]]; then
    CUrrenty="Y"
  else
    CUrrenty=""
  fi
  case $CUrrenty in
  Y)
    FOLDER_NAME3="$(grep "${YMXZ}" GITHUB_ENV |awk '{print $(2)}')"
    ECHOY "您选择了使用 ${FOLDER_NAME3} 编译固件,5秒后将进行启动编译"
    sleep 5
    Bendi_menu
  break
  ;;
  N)
    exit 0
  break
  ;;
  *)
    export YUMINGIP="敬告,请输入正确数值"
  ;;
  esac
  done
}


function menu2() {
  clear
  echo
  echo
  echo -e " ${Blue}当前使用源码${Font}：${Yellow}${FOLDER_NAME2}-${REPO_BRANCH2}${Font}"
  echo -e " ${Blue}成功编译过的机型${Font}：${Yellow}${TARGET_PROFILE2}${Font}"
  echo -e " ${Blue}DIY-SETUP/${FOLDER_NAME2}配置文件机型${Font}：${Yellow}${TARGET_PROFILE3}${Font}"
  echo
  echo
  echo -e " 1${Red}.${Font}${Green}保留缓存,再次编译${Font}"
  echo
  echo -e " 2${Red}.${Font}${Green}重新选择源码编译${Font}"
  echo
  echo -e " 3${Red}.${Font}${Green}同步上游OP_DIY文件(不覆盖config配置文件)${Font}"
  echo
  echo -e " 4${Red}.${Font}${Green}打包N1和晶晨系列CPU固件${Font}"
  echo
  echo -e " 5${Red}.${Font}${Green}退出${Font}"
  echo
  echo
  XUANZop="请输入数字"
  while :; do
  read -p " ${XUANZop}：" menu_num
  case $menu_num in
  1)
    Bendi_menu2
  break
  ;;
  2)
    Bendi_xuanzhe
  break
  ;;
  3)
    menu
  break
  ;;
  4)
    Bendi_Packaging
  break
  ;;
  5)
    echo
    exit 0
  break
  ;;
  *)
    XUANZop="请输入正确的数字编号!"
  ;;
  esac
  done
}

function menu() {
cd ${GITHUB_WORKSPACE}
clear
echo
ECHOY " 1. 进行选择编译源码文件"
ECHOYY " 2. 单独打包晶晨系列固件(前提是您要有armvirt的.tar.gz固件)"
ECHOY " 3. 退出编译程序"
echo
XUANZHEOP="请输入数字"
while :; do
read -p " ${XUANZHEOP}： " CHOOSE
case $CHOOSE in
1)
  Bendi_xuanzhe
break
;;
2)
  Bendi_Packaging
break
;;
3)
  ECHOR "您选择了退出编译程序"
  echo
  exit 0
break
;;
*)
   XUANZHEOP="请输入正确的数字编号!"
;;
esac
done
}

if [[ -d "${HOME_PATH}/package" && -d "${HOME_PATH}/target" && -d "${HOME_PATH}/toolchain" && -d "${GITHUB_WORKSPACE}/DIY-SETUP" && -f "${HOME_PATH}/diysetup" ]]; then
  source ${HOME_PATH}/diysetup
  if [[ -n "${FOLDER_NAME2}" ]] && [[ -n "${REPO_BRANCH2}" ]]; then
    if [[ `grep -c "CONFIG_TARGET_x86_64=y" "${GITHUB_WORKSPACE}/DIY-SETUP/${FOLDER_NAME2}/config"` -eq '1' ]]; then
      TARGET_PROFILE3="x86-64"
    elif [[ `grep -c "CONFIG_TARGET_x86=y" "${GITHUB_WORKSPACE}/DIY-SETUP/${FOLDER_NAME2}/config"` == '1' ]]; then
      TARGET_PROFILE3="x86_32"
    elif [[ `grep -c "CONFIG_TARGET_armvirt_64_Default=y" "${GITHUB_WORKSPACE}/DIY-SETUP/${FOLDER_NAME2}/config"` -eq '1' ]]; then
      TARGET_PROFILE3="Armvirt_64"
    else
      TARGET_PROFILE3="$(egrep -o "CONFIG_TARGET.*DEVICE.*=y" "${GITHUB_WORKSPACE}/DIY-SETUP/${FOLDER_NAME2}/config" | sed -r 's/.*DEVICE_(.*)=y/\1/')"
    fi
    menu2
  else
    menu
  fi
else
  menu
fi
