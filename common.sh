#!/bin/bash
# https://github.com/281677160/build-actions
# common Module by 28677160
# matrix.target=${matrixtarget}

function TIME() {
Compte=$(date +%Y年%m月%d号%H时%M分)
  [[ -z "$1" ]] && {
    echo -ne " "
    } || {
    case $1 in
    r) export Color="\e[31m";;
    g) export Color="\e[32m";;
    b) export Color="\e[34m";;
    y) export Color="\e[33m";;
    z) export Color="\e[35m";;
    l) export Color="\e[36m";;
    esac
      [[ $# -lt 2 ]] && echo -e "\e[36m\e[0m ${1}" || {
        echo -e "\e[36m\e[0m ${Color}${2}\e[0m"
      }
    }
}


function Diy_variable() {
if [[ ! ${bendi_script} == "1" ]]; then
  if [ -z "$(ls -A "${GITHUB_WORKSPACE}/build/${matrixtarget}/settings.ini" 2>/dev/null)" ]; then
    TIME r "错误提示：编译脚本缺少[settings.ini]名称的配置文件,请在[build/${matrixtarget}]文件夹内补齐"
    exit 1
  else
    source "${GITHUB_WORKSPACE}/build/${matrixtarget}/settings.ini"
  fi
fi

case "${SOURCE_CODE}" in
COOLSNOWWOLF)
  export REPO_URL="https://github.com/coolsnowwolf/lede"
  export SOURCE="Lede"
  export LUCI_EDITION="18.06"
  export MAINTAIN="Lede's"
  export PACKAGE_BRANCH="master"
  export ZZZ_PATH="${GITHUB_WORKSPACE}/openwrt/package/lean/default-settings/files/zzz-default-settings"
;;
LIENOL)
  export REPO_URL="https://github.com/Lienol/openwrt"
  export SOURCE="Lienol"
  export MAINTAIN="Lienol's"
  export ZZZ_PATH="${GITHUB_WORKSPACE}/openwrt/package/default-settings/files/zzz-default-settings"
  if [[ "${REPO_BRANCH}" == "master" ]]; then
    export PACKAGE_BRANCH="19.07"
    export LUCI_EDITION="master"
  elif [[ "${REPO_BRANCH}" == "21.02" ]]; then
    export PACKAGE_BRANCH="21.02"
    export LUCI_EDITION="21.02"
  elif [[ "${REPO_BRANCH}" == "19.07-cannotuse" ]]; then
    export PACKAGE_BRANCH="19.07"
    export LUCI_EDITION="19.07"
  elif [[ "${REPO_BRANCH}" == "19.07" ]]; then
    export PACKAGE_BRANCH="19.07"
    export LUCI_EDITION="17.01"
  fi
;;
IMMORTALWRT)
  export REPO_URL="https://github.com/immortalwrt/immortalwrt"
  export SOURCE="Immortalwrt"
  export MAINTAIN="ctcgfw's"
  export ZZZ_PATH="${GITHUB_WORKSPACE}/openwrt/package/emortal/default-settings/files/99-default-settings"
  if [[ "${REPO_BRANCH}" == "openwrt-21.02" ]]; then
    export PACKAGE_BRANCH="openwrt-21.02"
    export LUCI_EDITION="21.02"
  elif [[ "${REPO_BRANCH}" == "master" ]]; then
    export PACKAGE_BRANCH="openwrt-21.02"
    export LUCI_EDITION="master"
  elif [[ "${REPO_BRANCH}" == "openwrt-18.06" ]]; then
    export PACKAGE_BRANCH="openwrt-18.06"
    export LUCI_EDITION="18.06"
  elif [[ "${REPO_BRANCH}" == "openwrt-18.06-k5.4" ]]; then
    export PACKAGE_BRANCH="openwrt-18.06"
    export LUCI_EDITION="18.06-K54"
  fi
;;
XWRT)
  export REPO_URL="https://github.com/x-wrt/x-wrt"
  export SOURCE="Xwrt"
  export MAINTAIN="ptpt52"
  export PACKAGE_BRANCH="xwrt"
  export LUCI_EDITION="${REPO_BRANCH}"
  export ZZZ_PATH="${GITHUB_WORKSPACE}/openwrt/package/default-settings/files/zzz-default-settings"
;;
OFFICIAL)
  export REPO_URL="https://github.com/openwrt/openwrt"
  export SOURCE="Official"
  export MAINTAIN="openwrt"
  export PACKAGE_BRANCH="official"
  export LUCI_EDITION="${REPO_BRANCH}"
  export ZZZ_PATH="${GITHUB_WORKSPACE}/openwrt/package/default-settings/files/zzz-default-settings"
;;
AMLOGIC)
  export REPO_URL="https://github.com/coolsnowwolf/lede"
  export SOURCE="Amlogic"
  export LUCI_EDITION="18.06"
  export MAINTAIN="Lede's"
  export PACKAGE_BRANCH="master"
  export ZZZ_PATH="${GITHUB_WORKSPACE}/openwrt/package/lean/default-settings/files/zzz-default-settings"
;;
*)
  TIME r "不支持${SOURCE_CODE}此源码，当前只支持COOLSNOWWOLF、LIENOL、IMMORTALWRT、XWRT、OFFICIAL和AMLOGIC"
  exit 1
;;
esac

echo "HOME_PATH=${GITHUB_WORKSPACE}/openwrt" >> ${GITHUB_ENV}
echo "REPO_URL=${REPO_URL}" >> ${GITHUB_ENV}
echo "REPO_BRANCH=${REPO_BRANCH}" >> ${GITHUB_ENV}
echo "PACKAGE_BRANCH=${PACKAGE_BRANCH}" >> ${GITHUB_ENV}
echo "CONFIG_FILE=${CONFIG_FILE}" >> ${GITHUB_ENV}
echo "DIY_PART_SH=${DIY_PART_SH}" >> ${GITHUB_ENV}
echo "UPLOAD_FIRMWARE=${UPLOAD_FIRMWARE}" >> ${GITHUB_ENV}
echo "UPLOAD_CONFIG=${UPLOAD_CONFIG}" >> ${GITHUB_ENV}
echo "UPLOAD_WETRANSFER=${UPLOAD_WETRANSFER}" >> ${GITHUB_ENV}
echo "UPLOAD_RELEASE=${UPLOAD_RELEASE}" >> ${GITHUB_ENV}
echo "SERVERCHAN_SCKEY=${SERVERCHAN_SCKEY}" >> ${GITHUB_ENV}
echo "REGULAR_UPDATE=${REGULAR_UPDATE}" >> ${GITHUB_ENV}
echo "USE_CACHEWRTBUILD=${USE_CACHEWRTBUILD}" >> ${GITHUB_ENV}
echo "AUTOMATIC_AMLOGIC=${AUTOMATIC_AMLOGIC}" >> ${GITHUB_ENV}
echo "BY_INFORMATION=${BY_INFORMATION}" >> ${GITHUB_ENV}
echo "Library=${Warehouse##*/}" >> ${GITHUB_ENV}
echo "SOURCE_CODE=${SOURCE_CODE}" >> ${GITHUB_ENV}
echo "SOURCE=${SOURCE}" >> ${GITHUB_ENV}
echo "LUCI_EDITION=${LUCI_EDITION}" >> ${GITHUB_ENV}
echo "MAINTAIN=${MAINTAIN}" >> ${GITHUB_ENV}
echo "DIYWORKING=${matrixtarget}${REPO_BRANCH}" >> ${GITHUB_ENV}
  
echo "ZZZ_PATH=${ZZZ_PATH}" >> ${GITHUB_ENV}
echo "BUILD_PATH=${GITHUB_WORKSPACE}/openwrt/build/${matrixtarget}" >> ${GITHUB_ENV}
echo "BASE_PATH=${GITHUB_WORKSPACE}/openwrt/package/base-files/files" >> ${GITHUB_ENV}
echo "REPAIR_PATH=${GITHUB_WORKSPACE}/openwrt/package/base-files/files/etc/openwrt_release" >> ${GITHUB_ENV}
echo "DELETE=${GITHUB_WORKSPACE}/openwrt/package/base-files/files/etc/deletefile" >> ${GITHUB_ENV}
echo "FIN_PATH=${GITHUB_WORKSPACE}/openwrt/package/base-files/files/etc/default-setting" >> ${GITHUB_ENV}
echo "KEEPD=${GITHUB_WORKSPACE}/openwrt/package/base-files/files/lib/upgrade/keep.d/base-files-essential" >> ${GITHUB_ENV}
echo "GENE_PATH=${GITHUB_WORKSPACE}/openwrt/package/base-files/files/bin/config_generate" >> ${GITHUB_ENV}
echo "CLEAR_PATH=${GITHUB_WORKSPACE}/openwrt/Clear" >> ${GITHUB_ENV}
echo "Upgrade_Date=$(date +%Y%m%d%H%M)" >> ${GITHUB_ENV}
echo "Firmware_Date=$(date +%Y-%m%d-%H%M)" >> ${GITHUB_ENV}
echo "Compte_Date=$(date +%Y年%m月%d号%H时%M分)" >> ${GITHUB_ENV}
echo "Tongzhi_Date=$(date +%Y年%m月%d日)" >> ${GITHUB_ENV}
echo "Gujian_Date=$(date +%m.%d)" >> ${GITHUB_ENV}
}


function Diy_settings() {
echo "正在执行：判断是否缺少[${CONFIG_FILE}、${DIY_PART_SH}]文件"
  [[ -d "${OP_DIY}" ]] && {
    if [ -z "$(ls -A "${OP_DIY}/${matrixtarget}/${CONFIG_FILE}" 2>/dev/null)" ]; then
      TIME r "错误提示：编译脚本缺少[${CONFIG_FILE}]名称的配置文件,请在[${OP_DIY}/${matrixtarget}]文件夹内补齐"
      exit 1
    fi
    if [ -z "$(ls -A "${OP_DIY}/${matrixtarget}/${DIY_PART_SH}" 2>/dev/null)" ]; then
      TIME r "错误提示：编译脚本缺少[${DIY_PART_SH}]名称的自定义设置文件,请在[${OP_DIY}/${matrixtarget}]文件夹内补齐"
      exit 1
    fi
  } || {
    if [ -z "$(ls -A "${GITHUB_WORKSPACE}/build/${matrixtarget}/${CONFIG_FILE}" 2>/dev/null)" ]; then
      TIME r "错误提示：编译脚本缺少[${CONFIG_FILE}]名称的配置文件,请在[build/${matrixtarget}]文件夹内补齐"
      exit 1
    fi
    if [ -z "$(ls -A "${GITHUB_WORKSPACE}/build/${matrixtarget}/${DIY_PART_SH}" 2>/dev/null)" ]; then
      TIME r "错误提示：编译脚本缺少[${DIY_PART_SH}]名称的自定义设置文件,请在[build/${matrixtarget}]文件夹内补齐"
      exit 1
    fi
  }
}


function Diy_update() {
if [[ ! ${bendi_script} == "1" ]]; then
  export INS="sudo -E apt -qq"
else
  export INS="sudo apt"
fi
${INS} update -y
${INS} full-upgrade -y
sudo bash -c 'bash <(curl -s https://build-scripts.immortalwrt.eu.org/init_build_environment.sh)'
${INS} install -y rename
${INS} autoremove -y --purge
${INS} clean
}


function Diy_checkout() {
cd ${GITHUB_WORKSPACE}/openwrt
case "${SOURCE_CODE}" in
OFFICIAL)
  if [[ "${REPO_BRANCH}" =~ (openwrt-19.07|openwrt-21.02|openwrt-22.03) ]]; then
    export LUCI_EDITION="$(git tag| awk 'END {print}')"
    git checkout ${LUCI_EDITION}
    git switch -c ${LUCI_EDITION}
    export LUCI_EDITION="$(echo ${LUCI_EDITION} |sed 's/v//')"
    TIME g "正在使用${LUCI_EDITION}版本源码进行编译"
  else
    export LUCI_EDITION="${REPO_BRANCH}"
  fi
;;
esac
echo "LUCI_EDITION=${LUCI_EDITION}" >> ${GITHUB_ENV}
}


function Diy_Notice() {
export Model_Name="$(cat /proc/cpuinfo |grep 'model name' |awk 'END {print}' |cut -f2 -d: |sed 's/^[ ]*//g')"
export Cpu_Cores="$(cat /proc/cpuinfo | grep 'cpu cores' |awk 'END {print}' | cut -f2 -d: | sed 's/^[ ]*//g')"
export RAM_total="$(free -h |awk 'NR==2' |awk '{print $(2)}' |sed 's/.$//')"
export RAM_available="$(free -h |awk 'NR==2' |awk '{print $(7)}' |sed 's/.$//')"
TIME r ""
TIME y "第一次用我仓库的，请不要拉取任何插件，先SSH进入固件配置那里看过我脚本实在是没有你要的插件才再拉取"
TIME y "拉取插件应该单独拉取某一个你需要的插件，别一下子就拉取别人一个插件包，这样容易增加编译失败概率"
TIME r "修改IP、DNS、网关，请输入命令：openwrt"
TIME r "如果您的机子在线更新固件可用，而又编译了，也可请输入命令查看在线更新操作：openwrt"
TIME r ""
TIME r ""
TIME g "CPU性能：8370C > 8272CL > 8171M > E5系列"
TIME g "您现在编译所用的服务器CPU型号为[ ${Model_Name} ]"
TIME g "在此服务器分配核心数为[ ${Cpu_Cores} ],线程数为[ $(nproc) ]"
TIME g "在此服务器分配内存为[ ${RAM_total} ],现剩余内存为[ ${RAM_available} ]"
TIME r ""
}


function Diy_wenjian() {
# 拉取源码之后增加应用文件

cp ${HOME_PATH}/build/common/Custom/default-setting "${FIN_PATH}"
sudo chmod +x "${FIN_PATH}"
echo "sed -i 's?Development Snapshot?OpenWrt / ${SOURCE} - ${LUCI_EDITION}?g' /usr/lib/lua/luci/version.lua" >> "${FIN_PATH}"

cp ${HOME_PATH}/build/common/Custom/Postapplication "${BASE_PATH}/etc/init.d/Postapplication"
sudo chmod +x "${BASE_PATH}/etc/init.d/Postapplication"

[[ ! -d "${BASE_PATH}/usr/bin" ]] && mkdir -p ${BASE_PATH}/usr/bin
cp ${HOME_PATH}/build/common/Custom/openwrt.sh "${BASE_PATH}/usr/bin/openwrt"
sudo chmod +x "${BASE_PATH}/usr/bin/openwrt"

rm -rf "${DELETE}"
touch "${DELETE}"
sudo chmod +x "${DELETE}"


# 给固件保留配置更新固件的保留项目
cat >>"${KEEPD}" <<-EOF
/mnt/Detectionnetwork
/etc/config/AdGuardHome.yaml
/www/luci-static/argon/background
EOF
}


function Diy_clean() {
./scripts/feeds clean
./scripts/feeds update -a > /dev/null 2>&1
}


function Diy_COOLSNOWWOLF() {
# 删除重复插件（LEDE）
find . -name 'luci-theme-argon' -o -name 'luci-app-argon-config' -o -name 'mentohust' | xargs -i rm -rf {}
find . -name 'luci-app-wrtbwmon' -o -name 'wrtbwmon' -o -name 'luci-app-eqos' | xargs -i rm -rf {}
find . -name 'adguardhome' -o -name 'luci-app-adguardhome' -o -name 'luci-app-wol' | xargs -i rm -rf {}
find . -name 'mosdns' -o -name 'luci-app-mosdns' | xargs -i rm -rf {}
find . -name 'luci-app-smartdns' -o -name 'smartdns' | xargs -i rm -rf {}
  
# 给固件LUCI做个标记
sed -i '/DISTRIB_RECOGNIZE/d' "${REPAIR_PATH}"
echo -e "\nDISTRIB_RECOGNIZE='18'" >> "${REPAIR_PATH}" && sed -i '/^\s*$/d' "${REPAIR_PATH}"
}


function Diy_LIENOL() {
# 删除重复插件（Lienol）
find . -name 'luci-app-ttyd' -o -name 'luci-app-eqos' -o -name 'luci-theme-argon' -o -name 'luci-app-argon-config' | xargs -i rm -rf {}
find . -name 'adguardhome' -o -name 'luci-app-adguardhome' -o -name 'luci-app-wol' -o -name 'luci-app-dockerman' -o -name 'luci-app-frpc' | xargs -i rm -rf {}
find . -name 'luci-app-wrtbwmon' -o -name 'wrtbwmon' | xargs -i rm -rf {}
find . -name 'mosdns' -o -name 'luci-app-mosdns' | xargs -i rm -rf {}
find . -name 'luci-app-smartdns' -o -name 'smartdns' | xargs -i rm -rf {}
  
# 给固件LUCI做个标记
case "${REPO_BRANCH}" in
master)
  sed -i '/DISTRIB_RECOGNIZE/d' "${REPAIR_PATH}"
  echo -e "\nDISTRIB_RECOGNIZE='18'" >> "${REPAIR_PATH}" && sed -i '/^\s*$/d' "${REPAIR_PATH}"

;;
21.02)
  sed -i '/DISTRIB_RECOGNIZE/d' "${REPAIR_PATH}"
  echo -e "\nDISTRIB_RECOGNIZE='20'" >> "${REPAIR_PATH}" && sed -i '/^\s*$/d' "${REPAIR_PATH}"
  # Lienol大的21.02PW会显示缺少依赖，要修改一下
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/281677160/common-main/main/LIENOL/19.07/package/kernel/linux/modules/netsupport.sh)"

;;
19.07)
  sed -i '/DISTRIB_RECOGNIZE/d' "${REPAIR_PATH}"
  echo -e "\nDISTRIB_RECOGNIZE='18'" >> "${REPAIR_PATH}" && sed -i '/^\s*$/d' "${REPAIR_PATH}"
    
  # Lienol大的19.07补丁
  sed -i 's?PATCHVER:=.*?PATCHVER:=4.14?g' target/linux/x86/Makefile
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/281677160/common-main/main/LIENOL/19.07/package/kernel/linux/modules/netsupport.sh)"
  rm -rf feeds/packages/libs/libcap && svn co https://github.com/281677160/common-main/trunk/LIENOL/19.07/feeds/packages/libs/libcap feeds/packages/libs/libcap
  
;;
19.07-cannotuse)
  sed -i '/DISTRIB_RECOGNIZE/d' "${REPAIR_PATH}"
  echo -e "\nDISTRIB_RECOGNIZE='18'" >> "${REPAIR_PATH}" && sed -i '/^\s*$/d' "${REPAIR_PATH}"
    
  # Lienol大的19.07-cannotuse补丁
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/281677160/common-main/main/LIENOL/19.07/package/kernel/linux/modules/netsupport.sh)"
  rm -rf feeds/packages/libs/libcap && svn co https://github.com/281677160/common-main/trunk/LIENOL/19.07/feeds/packages/libs/libcap feeds/packages/libs/libcap
;;
esac

# 给源码增加passwall为默认自选
sed -i 's/luci-app-passwall //g' include/target.mk
sed -i 's?DEFAULT_PACKAGES:=?DEFAULT_PACKAGES:=luci-app-passwall ?g' include/target.mk
}


function Diy_IMMORTALWRT() {
# 删除重复插件（天灵）
find . -name 'luci-app-argon-config' -o -name 'luci-theme-argon' -o -name 'luci-theme-argonv3' -o -name 'luci-app-eqos' | xargs -i rm -rf {}
find . -name 'luci-app-openclash' -o -name 'luci-app-ssr-plus' -o -name 'luci-app-passwall' -o -name 'luci-app-passwall2' | xargs -i rm -rf {}
find . -name 'luci-app-cifs' -o -name 'luci-app-wrtbwmon' -o -name 'wrtbwmon' -o -name 'luci-app-wol' | xargs -i rm -rf {}
find . -name 'luci-app-adguardhome' -o -name 'adguardhome' -o -name 'luci-theme-opentomato' | xargs -i rm -rf {}
  
# 给固件LUCI做个标记
case "${REPO_BRANCH}" in
openwrt-21.02)
  sed -i '/DISTRIB_RECOGNIZE/d' "${REPAIR_PATH}"
  echo -e "\nDISTRIB_RECOGNIZE='20'" >> "${REPAIR_PATH}" && sed -i '/^\s*$/d' "${REPAIR_PATH}"
    
  export ttydjson="${HOME_PATH}/feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json"
  curl -fsSL https://raw.githubusercontent.com/281677160/common-main/main/IMMORTALWRT/ttyd/luci-app-ttyd.json > "${ttydjson}"
  
;;
master)
  find . -name 'default-settings' | xargs -i rm -rf {}
  svn export https://github.com/281677160/common-main/trunk/IMMORTALWRT/default-settings  ${HOME_PATH}/package/emortal/default-settings > /dev/null 2>&1
  if [[ `grep -c 'DEFAULT_PACKAGES.router:=default-settings luci luci-lib-ipkg' "${HOME_PATH}/include/target.mk"` -eq '0' ]]; then
    sed -i 's/default-settings-chn//g' "${HOME_PATH}/include/target.mk"
    sed -i 's/default-settings//g' "${HOME_PATH}/include/target.mk"
    sed -i 's?DEFAULT_PACKAGES.router:=?DEFAULT_PACKAGES.router:=default-settings luci luci-lib-ipkg ?g' "${HOME_PATH}/include/target.mk"
  fi
  
  sed -i '/DISTRIB_RECOGNIZE/d' "${REPAIR_PATH}"
  echo -e "\nDISTRIB_RECOGNIZE='20'" >> "${REPAIR_PATH}" && sed -i '/^\s*$/d' "${REPAIR_PATH}"
  
  sed -i '/attendedsysupgrade/d' "${HOME_PATH}/feeds/luci/collections/luci/Makefile"
    
  export ttydjson="${HOME_PATH}/feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json"
  curl -fsSL https://raw.githubusercontent.com/281677160/common-main/main/IMMORTALWRT/ttyd/luci-app-ttyd.json > "${ttydjson}"

;;
openwrt-18.06)
  sed -i '/DISTRIB_RECOGNIZE/d' "${REPAIR_PATH}"
  echo -e "\nDISTRIB_RECOGNIZE='18'" >> "${REPAIR_PATH}" && sed -i '/^\s*$/d' "${REPAIR_PATH}"

;;
openwrt-18.06-k5.4)
  sed -i '/DISTRIB_RECOGNIZE/d' "${REPAIR_PATH}"
  echo -e "\nDISTRIB_RECOGNIZE='18'" >> "${REPAIR_PATH}" && sed -i '/^\s*$/d' "${REPAIR_PATH}"

;;
esac
  
# 给源码增加luci-app-ssr-plus为默认自选
sed -i 's/luci-app-ssr-plus //g' include/target.mk
sed -i 's?DEFAULT_PACKAGES:=?DEFAULT_PACKAGES:=luci-app-ssr-plus ?g' include/target.mk
}


function Diy_XWRT() {
# 给固件LUCI做个标记
find . -name 'default-settings' -o -name 'luci-theme-argon' -o -name 'luci-app-argon-config' | xargs -i rm -rf {}
svn export https://github.com/281677160/common-main/trunk/OFFICIAL/default-settings  ${HOME_PATH}/package/default-settings > /dev/null 2>&1
svn export https://github.com/281677160/luci-theme-argon/branches/21.02 ${HOME_PATH}/package/luci-theme-argon > /dev/null 2>&1
svn export https://github.com/281677160/luci-theme-argon/branches/argon-config ${HOME_PATH}/package/luci-app-argon-config > /dev/null 2>&1

sed -i '/DISTRIB_RECOGNIZE/d' "${REPAIR_PATH}"
echo -e "\nDISTRIB_RECOGNIZE='21'" >> "${REPAIR_PATH}" && sed -i '/^\s*$/d' "${REPAIR_PATH}"

export ttydjson="${HOME_PATH}/feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json"
[[ -f "${ttydjson}" ]] && curl -fsSL https://raw.githubusercontent.com/281677160/common-main/main/IMMORTALWRT/ttyd/luci-app-ttyd.json > "${ttydjson}"

if [[ `grep -c 'attendedsysupgrade' "${HOME_PATH}/feeds/luci/collections/luci/Makefile"` -eq '1' ]]; then
  sed -i '/attendedsysupgrade/d' "feeds/luci/collections/luci/Makefile"
fi

sed -i 's?libustream-wolfssl?libustream-openssl?g' "${HOME_PATH}/include/target.mk"

if [[ `grep -c 'DEFAULT_PACKAGES.router:=dnsmasq' "include/target.mk"` -eq '1' ]] && [[ `grep -c 'default-settings dnsmasq-full' "include/target.mk"` -eq '0' ]]; then
  sed -i 's/default-settings//g' "${HOME_PATH}/include/target.mk"
  sed -i 's?DEFAULT_PACKAGES.router:=dnsmasq?DEFAULT_PACKAGES.router:=default-settings dnsmasq-full luci luci-compat luci-lib-ipkg?g' "${HOME_PATH}/include/target.mk"
elif [[ `grep -c 'DEFAULT_PACKAGES.router:=\\\\' "include/target.mk"` -eq '1' ]] && [[ `grep -c 'default-settings dnsmasq-full' "include/target.mk"` -eq '0' ]]; then
  sed -i 's/dnsmasq//g' "${HOME_PATH}/include/target.mk"
  sed -i 's?DEFAULT_PACKAGES.router:=\\?DEFAULT_PACKAGES.router:=default-settings dnsmasq-full luci luci-compat luci-lib-ipkg  \\?g' "${HOME_PATH}/include/target.mk"
elif [[ `grep -c 'default-settings' "${HOME_PATH}/include/target.mk"` -eq '0' ]]; then
  sed -i 's/dnsmasq-full//g' "${HOME_PATH}/include/target.mk"
  sed -i 's/dnsmasq//g' "${HOME_PATH}/include/target.mk"
  sed -i 's?DEFAULT_PACKAGES.router:=?DEFAULT_PACKAGES.router:=default-settings dnsmasq-full luci luci-compat luci-lib-ipkg  ?g' "${HOME_PATH}/include/target.mk"
fi

sed -i '/net.netfilter.nf_conntrack_max/d' ${HOME_PATH}/package/kernel/linux/files/sysctl-nf-conntrack.conf
echo "net.netfilter.nf_conntrack_helper = 1" >> ${HOME_PATH}/package/kernel/linux/files/sysctl-nf-conntrack.conf
}


function Diy_OFFICIAL() {
# 给固件LUCI做个标记
find . -name 'default-settings' -o -name 'luci-theme-argon' -o -name 'luci-app-argon-config' | xargs -i rm -rf {}
svn export https://github.com/281677160/common-main/trunk/OFFICIAL/default-settings ${HOME_PATH}/package/default-settings > /dev/null 2>&1
svn export https://github.com/281677160/luci-theme-argon/branches/21.02 ${HOME_PATH}/package/luci-theme-argon > /dev/null 2>&1
svn export https://github.com/281677160/luci-theme-argon/branches/argon-config ${HOME_PATH}/package/luci-app-argon-config > /dev/null 2>&1

sed -i '/DISTRIB_RECOGNIZE/d' "${REPAIR_PATH}"
echo -e "\nDISTRIB_RECOGNIZE='21'" >> "${REPAIR_PATH}" && sed -i '/^\s*$/d' "${REPAIR_PATH}"

export ttydjson="${HOME_PATH}/feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json"
[[ -f "${ttydjson}" ]] && curl -fsSL https://raw.githubusercontent.com/281677160/common-main/main/IMMORTALWRT/ttyd/luci-app-ttyd.json > "${ttydjson}"

if [[ `grep -c 'attendedsysupgrade' "${HOME_PATH}/feeds/luci/collections/luci/Makefile"` -eq '1' ]]; then
  sed -i '/attendedsysupgrade/d' "${HOME_PATH}/feeds/luci/collections/luci/Makefile"
fi

if [[ "${REPO_BRANCH}" = "openwrt-21.02" ]]; then
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/281677160/common-main/main/LIENOL/19.07/package/kernel/linux/modules/netsupport.sh)"
elif [[ "${REPO_BRANCH}" = "openwrt-19.07" ]]; then
  sed -i "s?+luci-lib-base?+luci-base?g" ${HOME_PATH}/package/default-settings/Makefile
fi

sed -i 's?libustream-wolfssl?libustream-openssl?g' "${HOME_PATH}/include/target.mk"

if [[ `grep -c 'DEFAULT_PACKAGES.router:=dnsmasq' "include/target.mk"` -eq '1' ]] && [[ `grep -c 'default-settings dnsmasq-full' "include/target.mk"` -eq '0' ]]; then
  sed -i 's/default-settings//g' "${HOME_PATH}/include/target.mk"
  sed -i 's?DEFAULT_PACKAGES.router:=dnsmasq?DEFAULT_PACKAGES.router:=default-settings dnsmasq-full luci luci-compat luci-lib-ipkg?g' "${HOME_PATH}/include/target.mk"
elif [[ `grep -c 'DEFAULT_PACKAGES.router:=\\\\' "include/target.mk"` -eq '1' ]] && [[ `grep -c 'default-settings dnsmasq-full' "include/target.mk"` -eq '0' ]]; then
  sed -i 's/dnsmasq//g' "${HOME_PATH}/include/target.mk"
  sed -i 's?DEFAULT_PACKAGES.router:=\\?DEFAULT_PACKAGES.router:=default-settings dnsmasq-full luci luci-compat luci-lib-ipkg  \\?g' "${HOME_PATH}/include/target.mk"
elif [[ `grep -c 'default-settings' "${HOME_PATH}/include/target.mk"` -eq '0' ]]; then
  sed -i 's/dnsmasq-full//g' "${HOME_PATH}/include/target.mk"
  sed -i 's/dnsmasq//g' "${HOME_PATH}/include/target.mk"
  sed -i 's?DEFAULT_PACKAGES.router:=?DEFAULT_PACKAGES.router:=default-settings dnsmasq-full luci luci-compat luci-lib-ipkg  ?g' "${HOME_PATH}/include/target.mk"
fi

sed -i '/net.netfilter.nf_conntrack_max/d' ${HOME_PATH}/package/kernel/linux/files/sysctl-nf-conntrack.conf
echo "net.netfilter.nf_conntrack_helper = 1" >> ${HOME_PATH}/package/kernel/linux/files/sysctl-nf-conntrack.conf
}


function Diy_AMLOGIC() {
# 删除重复插件（LEDE - N1等）
find . -name 'luci-theme-argon' -o -name 'luci-app-argon-config' -o -name 'mentohust' | xargs -i rm -rf {}
find . -name 'luci-app-wrtbwmon' -o -name 'wrtbwmon' -o -name 'luci-app-eqos' | xargs -i rm -rf {}
find . -name 'adguardhome' -o -name 'luci-app-adguardhome' -o -name 'luci-app-wol' | xargs -i rm -rf {}
find . -name 'mosdns' -o -name 'luci-app-mosdns' | xargs -i rm -rf {}
find . -name 'luci-app-smartdns' -o -name 'smartdns' | xargs -i rm -rf {}
  
# 给固件LUCI做个标记
sed -i '/DISTRIB_RECOGNIZE/d' "${REPAIR_PATH}"
echo -e "\nDISTRIB_RECOGNIZE='18'" >> "${REPAIR_PATH}" && sed -i '/^\s*$/d' "${REPAIR_PATH}"

# 修复NTFS格式优盘不自动挂载
packages=" \
block-mount fdisk usbutils badblocks ntfs-3g kmod-scsi-core kmod-usb-core \
kmod-usb-ohci kmod-usb-uhci kmod-usb-storage kmod-usb-storage-extras kmod-usb2 kmod-usb3 \
kmod-fs-ext4 kmod-fs-vfat kmod-fuse luci-app-amlogic unzip curl \
brcmfmac-firmware-43430-sdio brcmfmac-firmware-43455-sdio kmod-brcmfmac wpad \
lscpu htop iperf3 curl lm-sensors python3 losetup resize2fs tune2fs pv blkid lsblk parted \
kmod-usb-net kmod-usb-net-asix-ax88179 kmod-usb-net-rtl8150 kmod-usb-net-rtl8152
"
sed -i '/FEATURES+=/ { s/cpiogz //; s/ext4 //; s/ramdisk //; s/squashfs //; }' ${HOME_PATH}/target/linux/armvirt/Makefile
for x in $packages; do
  sed -i "/DEFAULT_PACKAGES/ s/$/ $x/" ${HOME_PATH}/target/linux/armvirt/Makefile
done

# 修改cpufreq和autocore一些代码适配amlogic
sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' ${HOME_PATH}/feeds/luci/applications/luci-app-cpufreq/Makefile
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' ${HOME_PATH}/package/lean/autocore/Makefile
}


function Diy_distrib() {
if [ ! "${SOURCE_CODE}" == "COOLSNOWWOLF" ]; then
sed -i "s?main.lang=.*?main.lang='zh_cn'?g" "${ZZZ_PATH}"
sed -i '/DISTRIB_/d' "${ZZZ_PATH}"
sed -i '/luciversion/d' "${ZZZ_PATH}"
sed -i '/luciname/d' "${ZZZ_PATH}"
sed -i '/exit 0/d' "${ZZZ_PATH}"

cat >>"${ZZZ_PATH}" <<-EOF
sed -i '/DISTRIB_REVISION/d' /etc/openwrt_release
echo "DISTRIB_REVISION=''${LUCI_EDITION}''" >> /etc/openwrt_release
sed -i '/DISTRIB_DESCRIPTION/d' /etc/openwrt_release
echo "DISTRIB_DESCRIPTION='OpenWrt '" >> /etc/openwrt_release
sed -i '/luciversion/d' /usr/lib/lua/luci/version.lua
echo "luciversion    = \"${SOURCE}\"" >> /usr/lib/lua/luci/version.lua
sed -i '/luciname/d' /usr/lib/lua/luci/version.lua
echo "luciname    = \"- ${LUCI_EDITION}\"" >> /usr/lib/lua/luci/version.lua
exit 0
EOF
fi
}


function Diy_chajianyuan() {
if [[ "$(. ${BASE_PATH}/etc/openwrt_release && echo "$DISTRIB_RECOGNIZE")" != "21" ]]; then
echo "正在执行：给feeds.conf.default增加插件源"
# 这里增加了源,要对应的删除/etc/opkg/distfeeds.conf插件源
echo "
src-git danshui https://github.com/281677160/openwrt-package.git;${PACKAGE_BRANCH}
src-git helloworld https://github.com/fw876/helloworld
src-git passwall https://github.com/xiaorouji/openwrt-passwall;packages
src-git passwall1 https://github.com/xiaorouji/openwrt-passwall;luci
src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2;main
" >> ${HOME_PATH}/feeds.conf.default
sed -i '/^#/d' "${HOME_PATH}/feeds.conf.default"
sed -i '/^$/d' "${HOME_PATH}/feeds.conf.default"
fi
}


function Diy_files() {
echo "正在执行：files大法，设置固件无烦恼"
if [[ -d "${GITHUB_WORKSPACE}/OP_DIY" ]]; then
  cp -Rf ${GITHUB_WORKSPACE}/OP_DIY/${matrixtarget}/* ${BUILD_PATH}
fi

if [ -n "$(ls -A "${BUILD_PATH}/patches" 2>/dev/null)" ]; then
  find "${BUILD_PATH}/patches" -type f -name '*.patch' -print0 | sort -z | xargs -I % -t -0 -n 1 sh -c "cat '%'  | patch -d './' -p1 --forward --no-backup-if-mismatch"
fi

if [ -n "$(ls -A "${BUILD_PATH}/diy" 2>/dev/null)" ]; then
  cp -Rf ${BUILD_PATH}/diy/* ${HOME_PATH}
fi

if [ -n "$(ls -A "${BUILD_PATH}/files" 2>/dev/null)" ]; then
  cp -Rf ${BUILD_PATH}/files ${HOME_PATH}
fi
chmod -R 775 ${HOME_PATH}/files
rm -rf ${HOME_PATH}/files/{LICENSE,README,REA*.md}
}


function Diy_Publicarea() {
# diy-part.sh文件的延伸
rm -rf ${HOME_PATH}/CHONGTU && touch ${HOME_PATH}/CHONGTU
sed -i '/lan.gateway=/d' "${GENE_PATH}"
sed -i '/lan.dns=/d' "${GENE_PATH}"
sed -i '/lan.broadcast=/d' "${GENE_PATH}"
sed -i '/lan.ignore=/d' "${GENE_PATH}"
sed -i '/lan.type/d' "${GENE_PATH}"
sed -i '/set ttyd/d' "${GENE_PATH}"
export lan="/set network.\$1.netmask/a"
export ipadd="$(grep "ipaddr:-" "${GENE_PATH}" |egrep -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
export netmas="$(grep "netmask:-" "${GENE_PATH}" |egrep -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
export opname="$(grep "hostname='" "${GENE_PATH}" |cut -d "'" -f2)"


if [[ "${OpenClash_branch}" != "master" ]] || [[ "${OpenClash_branch}" != "dev" ]]; then
   echo "OpenClash_branch=master" >> ${GITHUB_ENV}
else
   echo "OpenClash_branch=${OpenClash_branch}" >> ${GITHUB_ENV}
fi


if [[ "${Package_IPv6helper}" == "1" ]]; then
  export Create_IPV6_interface="0"
  export Remove_IPv6="0"
  echo "Package_IPv6helper=1" >> ${GITHUB_ENV}
echo "
uci set network.lan.ip6assign='64'
uci commit network
uci set dhcp.lan.ra='server'
uci set dhcp.lan.dhcpv6='server'
uci set dhcp.lan.ra_management='1'
uci set dhcp.lan.ra_default='1'
uci set dhcp.@dnsmasq[0].localservice=0
uci set dhcp.@dnsmasq[0].nonwildcard=0
uci set dhcp.@dnsmasq[0].filter_aaaa='0'
uci commit dhcp
/etc/init.d/dnsmasq restart
/etc/init.d/odhcpd restart
" >> "${FIN_PATH}"
fi

if [[ "${Create_IPV6_interface}" == "1" ]]; then
  echo "Create_IPV6_interface=1" >> ${GITHUB_ENV}
  export Remove_IPv6="0"
echo '
uci delete network.lan.ip6assign
uci set network.lan.delegate='0'
uci commit network
uci delete dhcp.lan.ra
uci delete dhcp.lan.ra_management
uci delete dhcp.lan.ra_default
uci delete dhcp.lan.dhcpv6
uci delete dhcp.lan.ndp
uci set dhcp.@dnsmasq[0].filter_aaaa='0'
uci commit dhcp
uci set network.ipv6=interface
uci set network.ipv6.proto='dhcpv6'
uci set network.ipv6.${ifname}='@lan'
uci set network.ipv6.reqaddress='try'
uci set network.ipv6.reqprefix='auto'
uci commit network
uci set firewall.@zone[0].network='lan ipv6'
uci commit firewall
/etc/init.d/network restart
/etc/init.d/dnsmasq restart
/etc/init.d/odhcpd restart
' >> "${FIN_PATH}"
fi

if [[ "${Remove_IPv6}" == "1" ]]; then
echo "
uci delete network.globals.ula_prefix
uci delete network.lan.ip6assign
uci delete network.wan6
uci set network.lan.delegate='0' 
uci commit network
uci delete dhcp.lan.ra
uci delete dhcp.lan.ra_management
uci delete dhcp.lan.ra_default
uci delete dhcp.lan.dhcpv6
uci delete dhcp.lan.ndp
uci set dhcp.@dnsmasq[0].filter_aaaa='1'
uci commit dhcp
/etc/init.d/network restart
/etc/init.d/dnsmasq restart
/etc/init.d/odhcpd restart
" >> "${FIN_PATH}"
fi

if [[ ! "${Required_Topic}" == "0" ]] && [[ -n "${Required_Topic}" ]]; then
  echo "Required_Topic=${Required_Topic}" >> ${GITHUB_ENV}
fi

if [[ ! "${Default_Theme}" == "0" ]] && [[ -n "${Default_Theme}" ]]; then
  echo "Default_Theme=${Default_Theme}" >> ${GITHUB_ENV}
fi

if [[ ! "${Personal_Signature}" == "0" ]] && [[ -n "${Personal_Signature}" ]]; then
   sed -i "s?OpenWrt ?${Personal_Signature} @ OpenWrt ?g" "${ZZZ_PATH}"
   sed -i "s?OpenWrt ?${Personal_Signature} @ OpenWrt ?g" "${FIN_PATH}"
fi

if [[ "${Delete_NotRequired}" == "1" ]]; then
   echo "Delete_NotRequired=${Delete_NotRequired}" >> ${GITHUB_ENV}
fi

if [[ ! "${Kernel_Patchver}" == "0" ]] && [[ -n "${Kernel_Patchver}" ]]; then
  echo "Kernel_Patchver=${Kernel_Patchver}" >> ${GITHUB_ENV}
fi

if [[ ! "${IPv4_ipaddr}" == "0" ]] && [[ -n "${IPv4_ipaddr}" ]]; then
  export Kernel_Pat="$(echo ${IPv4_ipaddr} |egrep -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
  export ipadd_Pat="$(echo ${ipadd} |egrep -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
  if [[ -n "${Kernel_Pat}" ]] && [[ -n "${ipadd_Pat}" ]]; then
     sed -i "s/${ipadd}/${IPv4_ipaddr}/g" "${GENE_PATH}"
   else
     echo "TIME r \"因IP获取有错误，后台IP更换不成功，请检查IP是否填写正确，如果填写正确，那就是获取不了源码内的IP了\"" >> ${HOME_PATH}/CHONGTU
   fi
fi

if [[ ! "${Netmask_netm}" == "0" ]] && [[ -n "${Netmask_netm}" ]]; then
  export Kernel_netm="$(echo ${Netmask_netm} |egrep -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
  export ipadd_mas="$(echo ${netmas} |egrep -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
  if [[ -n "${Kernel_netm}" ]] && [[ -n "${ipadd_mas}" ]]; then
     sed -i "s/${netmas}/${Netmask_netm}/g" "${GENE_PATH}"
   else
     echo "TIME r \"因子网掩码获取有错误，子网掩码设置失败，请检查IP是否填写正确，如果填写正确，那就是获取不了源码内的IP了\"" >> ${HOME_PATH}/CHONGTU
   fi
fi

if [[ ! "${Op_name}" == "0" ]] && [[ -n "${Op_name}" ]] && [[ -n "${opname}" ]]; then
   sed -i "s/${opname}/${Op_name}/g" "${GENE_PATH}"
fi

if [[ ! "${Router_gateway}" == "0" ]] && [[ -n "${Router_gateway}" ]]; then
   export Router_gat="$(echo ${Router_gateway} |egrep -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
   if [[ -n "${Router_gat}" ]]; then
     sed -i "$lan\set network.lan.gateway='${Router_gateway}'" "${GENE_PATH}"
   else
     echo "TIME r \"因子网关IP获取有错误，网关IP设置失败，请检查IP是否填写正确，如果填写正确，那就是获取不了源码内的IP了\"" >> ${HOME_PATH}/CHONGTU
   fi
fi

if [[ ! "${Lan_DNS}" == "0" ]] && [[ -n "${Lan_DNS}" ]]; then
  export ipa_dns="$(echo ${Lan_DNS} |egrep -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
  if [[ -n "${ipa_dns}" ]]; then
     sed -i "$lan\set network.lan.dns='${Lan_DNS}'" "${GENE_PATH}"
   else
     echo "TIME r \"因DNS获取有错误，DNS设置失败，请检查DNS是否填写正确\"" >> ${HOME_PATH}/CHONGTU
   fi
fi

if [[ ! "${IPv4_Broadcast}" == "0" ]] && [[ -n "${IPv4_Broadcast}" ]]; then
  export IPv4_Bro="$(echo ${IPv4_Broadcast} |egrep -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
  if [[ -n "${IPv4_Bro}" ]]; then
     sed -i "$lan\set network.lan.broadcast='${IPv4_Broadcast}'" "${GENE_PATH}"
   else
     echo "TIME r \"因IPv4 广播IP获取有错误，IPv4广播IP设置失败，请检查IPv4广播IP是否填写正确\"" >> ${HOME_PATH}/CHONGTU
   fi
fi

if [[ "${Close_DHCP}" == "1" ]]; then
   sed -i "$lan\set dhcp.lan.ignore='1'" "${GENE_PATH}"
fi

if [[ "${Delete_Bridge}" == "1" ]]; then
   sed -i "$lan\delete network.lan.type" "${GENE_PATH}"
fi

if [[ "${ttyd_Nopassword}" == "1" ]]; then
   sed -i "$lan\set ttyd.@ttyd[0].command='/bin/login -f root'" "${GENE_PATH}"
fi

if [[ "${Confidentiality_free}" == "1" ]]; then
   sed -i '/CYXluq4wUazHjmCDBCqXF/d' "${ZZZ_PATH}"
fi

if [[ "${Remove_Firewall}" == "1" ]]; then
   sed -i '/to-ports 53/d' "${ZZZ_PATH}"
fi

if [[ "${Cancel_running}" == "1" ]]; then
   echo "sed -i '/coremark/d' /etc/crontabs/root" >> "${FIN_PATH}"
fi

# 晶晨CPU机型自定义机型,内核,分区
if [[ -n "${amlogic_model}" ]] && [[ "${SOURCE_CODE}" == "AMLOGIC" ]]; then
  echo "amlogic_model=${amlogic_model}" >> ${GITHUB_ENV}
elif [[ -z "${amlogic_model}" ]] && [[ "${SOURCE_CODE}" == "AMLOGIC" ]]; then
  echo "amlogic_model=s905d" >> ${GITHUB_ENV}
fi
if [[ -n "${amlogic_kernel}" ]] && [[ "${SOURCE_CODE}" == "AMLOGIC" ]]; then
  echo "amlogic_kernel=${amlogic_kernel}" >> ${GITHUB_ENV}
elif [[ -z "${amlogic_kernel}" ]] && [[ "${SOURCE_CODE}" == "AMLOGIC" ]]; then
  echo "amlogic_kernel=5.4.210_5.10.135_5.15.50 -a true" >> ${GITHUB_ENV}
fi
if [[ -n "${rootfs_size}" ]] && [[ "${SOURCE_CODE}" == "AMLOGIC" ]]; then
  echo "rootfs_size=${rootfs_size}" >> ${GITHUB_ENV}
elif [[ -z "${rootfs_size}" ]] && [[ "${SOURCE_CODE}" == "AMLOGIC" ]]; then
  echo "rootfs_size=960" >> ${GITHUB_ENV}
fi
}


function Diy_part_sh() {
cd ${HOME_PATH}
# 修正连接数
sed -i '/net.netfilter.nf_conntrack_max/d' ${HOME_PATH}/package/base-files/files/etc/sysctl.conf
echo -e "\nnet.netfilter.nf_conntrack_max=165535" >> ${HOME_PATH}/package/base-files/files/etc/sysctl.conf

# openclash分支选择
if [[ "$(. ${BASE_PATH}/etc/openwrt_release && echo "$DISTRIB_RECOGNIZE")" != "21" ]]; then
  find . -name 'luci-app-openclash' | xargs -i rm -rf {}
  git clone -b "${OpenClash_branch}" --depth 1 https://github.com/vernesong/OpenClash package/luci-app-openclash
  echo "正在使用"${OpenClash_branch}"分支的openclash"
fi
}


function Diy_upgrade1() {
if [[ "${REGULAR_UPDATE}" == "true" ]]; then
  source ${BUILD_PATH}/upgrade.sh && Diy_Part1
fi
}


function Diy_Language() {
if [[ "$(. ${BASE_PATH}/etc/openwrt_release && echo "$DISTRIB_RECOGNIZE")" != "18" ]]; then
  echo "正在执行：把插件语言转换成zh_Hans"
  cd ${HOME_PATH}
  cp -Rf ${HOME_PATH}/build/common/language/zh_Hans.sh ${HOME_PATH}/zh_Hans.sh
  chmod +x ${HOME_PATH}/zh_Hans.sh
  /bin/bash ${HOME_PATH}/zh_Hans.sh
  rm -rf ${HOME_PATH}/zh_Hans.sh
fi
}


function Diy_feeds() {
echo "正在执行：更新feeds,请耐心等待..."
cd ${HOME_PATH}
./scripts/feeds update -a
./scripts/feeds install -a > /dev/null 2>&1
./scripts/feeds install -a
[[ -f ${BUILD_PATH}/$CONFIG_FILE ]] && mv ${BUILD_PATH}/$CONFIG_FILE .config

if [[ ! "${Required_Topic}" == "0" ]] && [[ -n "${Required_Topic}" ]]; then
  export themee=luci-theme-${Required_Topic}
  find . -name ${themee} -type d |tee themeuci
  if [[ -s "themeuci" ]]; then
    sed -i "s/bootstrap/${Required_Topic}/g" ${HOME_PATH}/feeds/luci/collections/luci/Makefile
    rm -rf themeuci
  else
    rm -rf themeuci
    echo "TIME r \"没有${themee}此主题存在,不进行替换bootstrap主题操作\"" >> ${HOME_PATH}/CHONGTU
  fi
fi
}


function Diy_IPv6helper() {
if [[ "${Package_IPv6helper}" == "1" ]] || [[ "${Create_IPV6_interface}" == "1" ]]; then
echo '
CONFIG_PACKAGE_ipv6helper=y
CONFIG_PACKAGE_ip6tables=y
CONFIG_PACKAGE_dnsmasq_full_dhcpv6=y
CONFIG_PACKAGE_odhcp6c=y
CONFIG_PACKAGE_odhcpd-ipv6only=y
CONFIG_IPV6=y
CONFIG_PACKAGE_6rd=y
CONFIG_PACKAGE_6to4=y
' >> ${HOME_PATH}/.config
fi
}


function Diy_prevent() {
Diy_IPv6helper
echo "正在执行：判断插件有否冲突减少编译错误"
make defconfig > /dev/null 2>&1
if [[ `grep -c "CONFIG_PACKAGE_luci-app-ipsec-server=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-ipsec-vpnd=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-ipsec-vpnd=y/# CONFIG_PACKAGE_luci-app-ipsec-vpnd is not set/g' ${HOME_PATH}/.config
    echo "TIME r \"您同时选择luci-app-ipsec-vpnd和luci-app-ipsec-server，插件有冲突，相同功能插件只能二选一，已删除luci-app-ipsec-vpnd\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-docker=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-dockerman=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-docker=y/# CONFIG_PACKAGE_luci-app-docker is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_luci-i18n-docker-zh-cn=y/# CONFIG_PACKAGE_luci-i18n-docker-zh-cn is not set/g' ${HOME_PATH}/.config
    echo "TIME r \"您同时选择luci-app-docker和luci-app-dockerman，插件有冲突，相同功能插件只能二选一，已删除luci-app-docker\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-qbittorrent=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-qbittorrent-simple=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-qbittorrent-simple=y/# CONFIG_PACKAGE_luci-app-qbittorrent-simple is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_luci-i18n-qbittorrent-simple-zh-cn=y/# CONFIG_PACKAGE_luci-i18n-qbittorrent-simple-zh-cn is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_qbittorrent=y/# CONFIG_PACKAGE_qbittorrent is not set/g' ${HOME_PATH}/.config
    echo "TIME r \"您同时选择luci-app-qbittorrent和luci-app-qbittorrent-simple，插件有冲突，相同功能插件只能二选一，已删除luci-app-qbittorrent-simple\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-advanced=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-fileassistant=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-fileassistant=y/# CONFIG_PACKAGE_luci-app-fileassistant is not set/g' ${HOME_PATH}/.config
    echo "TIME r \"您同时选择luci-app-advanced和luci-app-fileassistant，luci-app-advanced已附带luci-app-fileassistant，所以删除了luci-app-fileassistant\"" >>CHONGTU
    echo "" >>CHONGTU
   fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-adblock-plus=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-adblock=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-adblock=y/# CONFIG_PACKAGE_luci-app-adblock is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_adblock=y/# CONFIG_PACKAGE_adblock is not set/g' ${HOME_PATH}/.config
    sed -i '/luci-i18n-adblock/d' ${HOME_PATH}/.config
    echo "TIME r \"您同时选择luci-app-adblock-plus和luci-app-adblock，插件有依赖冲突，只能二选一，已删除luci-app-adblock\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-kodexplorer=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-vnstat=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-vnstat=y/# CONFIG_PACKAGE_luci-app-vnstat is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_vnstat=y/# CONFIG_PACKAGE_vnstat is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_vnstati=y/# CONFIG_PACKAGE_vnstati is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_libgd=y/# CONFIG_PACKAGE_libgd is not set/g' ${HOME_PATH}/.config
    sed -i '/luci-i18n-vnstat/d' ${HOME_PATH}/.config
    echo "TIME r \"您同时选择luci-app-kodexplorer和luci-app-vnstat，插件有依赖冲突，只能二选一，已删除luci-app-vnstat\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-ssr-plus=y" ${HOME_PATH}/.config` -ge '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-cshark=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-cshark=y/# CONFIG_PACKAGE_luci-app-cshark is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_cshark=y/# CONFIG_PACKAGE_cshark is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_libustream-mbedtls=y/# CONFIG_PACKAGE_libustream-mbedtls is not set/g' ${HOME_PATH}/.config
    echo "TIME r \"您同时选择luci-app-ssr-plus和luci-app-cshark，插件有依赖冲突，只能二选一，已删除luci-app-cshark\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_wpad-openssl=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_wpad=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_wpad=y/# CONFIG_PACKAGE_wpad is not set/g' ${HOME_PATH}/.config
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_antfs-mount=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_ntfs3-mount=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_antfs-mount=y/# CONFIG_PACKAGE_antfs-mount is not set/g' ${HOME_PATH}/.config
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_dnsmasq-full=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_dnsmasq=y" ${HOME_PATH}/.config` -eq '1' ]] || [[ `grep -c "CONFIG_PACKAGE_dnsmasq-dhcpv6=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_dnsmasq=y/# CONFIG_PACKAGE_dnsmasq is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_dnsmasq-dhcpv6=y/# CONFIG_PACKAGE_dnsmasq-dhcpv6 is not set/g' ${HOME_PATH}/.config
  fi
  if [[ `grep -c "CONFIG_PACKAGE_dnsmasq_full_conntrack=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_dnsmasq_full_conntrack=y/# CONFIG_PACKAGE_dnsmasq_full_conntrack is not set/g' ${HOME_PATH}/.config
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-samba4=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-samba=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_autosamba=y/# CONFIG_PACKAGE_autosamba is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_luci-app-samba=y/# CONFIG_PACKAGE_luci-app-samba is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_luci-i18n-samba-zh-cn=y/# CONFIG_PACKAGE_luci-i18n-samba-zh-cn is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_samba36-server=y/# CONFIG_PACKAGE_samba36-server is not set/g' ${HOME_PATH}/.config
    echo "TIME r \"您同时选择luci-app-samba和luci-app-samba4，插件有冲突，相同功能插件只能二选一，已删除luci-app-samba\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-theme-argon=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  pmg="$(echo "$(date +%d)" | sed 's/^.//g')"
  mkdir -p ${HOME_PATH}/files/www/luci-static/argon/background
  curl -fsSL  https://raw.githubusercontent.com/281677160/openwrt-package/usb/argon/jpg/${pmg}.jpg > ${HOME_PATH}/files/www/luci-static/argon/background/moren.jpg
  if [[ $? -ne 0 ]]; then
    echo "拉取文件错误,请检测网络"
    exit 1
  fi
  if [[ `grep -c "CONFIG_PACKAGE_luci-theme-argon_new=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-theme-argon_new=y/# CONFIG_PACKAGE_luci-theme-argon_new is not set/g' ${HOME_PATH}/.config
    echo "TIME r \"您同时选择luci-theme-argon和luci-theme-argon_new，插件有冲突，相同功能插件只能二选一，已删除luci-theme-argon_new\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-theme-argon=y" ${HOME_PATH}/.config` -eq '1' ]] && [[ `grep -c "CONFIG_TARGET_x86=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-argon-config=y" ${HOME_PATH}/.config` -eq '0' ]]; then
    sed -i '/argon-config/d' "${HOME_PATH}/.config"
    sed -i '/argon=y/i\CONFIG_PACKAGE_luci-app-argon-config=y' "${HOME_PATH}/.config"
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-sfe=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-flowoffload=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_DEFAULT_luci-app-flowoffload=y/# CONFIG_DEFAULT_luci-app-flowoffload is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_luci-app-flowoffload=y/# CONFIG_PACKAGE_luci-app-flowoffload is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_luci-i18n-flowoffload-zh-cn=y/# CONFIG_PACKAGE_luci-i18n-flowoffload-zh-cn is not set/g' ${HOME_PATH}/.config
    echo "TIME r \"提示：您同时选择了luci-app-sfe和luci-app-flowoffload，两个ACC网络加速，已删除luci-app-flowoffload\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-ssl=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_libustream-wolfssl=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-ssl=y/# CONFIG_PACKAGE_luci-ssl is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_libustream-wolfssl=y/CONFIG_PACKAGE_libustream-wolfssl=m/g' ${HOME_PATH}/.config
    echo "TIME r \"您选择了luci-ssl会自带libustream-wolfssl，会和libustream-openssl冲突导致编译错误，已删除luci-ssl\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-unblockneteasemusic=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-unblockneteasemusic-go=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-unblockneteasemusic-go=y/# CONFIG_PACKAGE_luci-app-unblockneteasemusic-go is not set/g' ${HOME_PATH}/.config
    echo "TIME r \"您选择了luci-app-unblockneteasemusic-go，会和luci-app-unblockneteasemusic冲突导致编译错误，已删除luci-app-unblockneteasemusic-go\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-unblockmusic=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-unblockmusic=y/# CONFIG_PACKAGE_luci-app-unblockmusic is not set/g' ${HOME_PATH}/.config
    echo "TIME r \"您选择了luci-app-unblockmusic，会和luci-app-unblockneteasemusic冲突导致编译错误，已删除luci-app-unblockmusic\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_ntfs-3g=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  mkdir -p ${HOME_PATH}/files/etc/hotplug.d/block && curl -fsSL  https://raw.githubusercontent.com/281677160/openwrt-package/usb/block/10-mount > ${HOME_PATH}/files/etc/hotplug.d/block/10-mount
  if [[ $? -ne 0 ]]; then
    echo "拉取文件错误,请检测网络"
    exit 1
  fi
fi

if [[ `grep -c "CONFIG_TARGET_x86=y" ${HOME_PATH}/.config` -eq '1' ]]; then
echo -e "\nCONFIG_PACKAGE_snmpd=y" >> "${HOME_PATH}/.config"
fi

if [[ `grep -c "CONFIG_TARGET_x86=y" ${HOME_PATH}/.config` -eq '1' ]] || [[ `grep -c "CONFIG_TARGET_rockchip=y" ${HOME_PATH}/.config` -eq '1' ]] || [[ `grep -c "CONFIG_TARGET_bcm27xx=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  sed -i '/IMAGES_GZIP/d' "${HOME_PATH}/.config"
  echo -e "\nCONFIG_TARGET_IMAGES_GZIP=y" >> "${HOME_PATH}/.config"
  sed -i '/CONFIG_PACKAGE_openssh-sftp-server/d' "${HOME_PATH}/.config"
  echo -e "\nCONFIG_PACKAGE_openssh-sftp-server=y" >> "${HOME_PATH}/.config"
  sed -i '/CONFIG_GRUB_IMAGES/d' "${HOME_PATH}/.config"
  echo -e "\nCONFIG_GRUB_IMAGES=y" >> "${HOME_PATH}/.config"
fi
if [[ `grep -c "CONFIG_TARGET_mxs=y" ${HOME_PATH}/.config` -eq '1' ]] || [[ `grep -c "CONFIG_TARGET_sunxi=y" ${HOME_PATH}/.config` -eq '1' ]] || [[ `grep -c "CONFIG_TARGET_zynq=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  sed -i '/IMAGES_GZIP/d' "${HOME_PATH}/.config"
  echo -e "\nCONFIG_TARGET_IMAGES_GZIP=y" >> "${HOME_PATH}/.config"
  sed -i '/CONFIG_PACKAGE_openssh-sftp-server/d' "${HOME_PATH}/.config"
  echo -e "\nCONFIG_PACKAGE_openssh-sftp-server=y" >> "${HOME_PATH}/.config"
  sed -i '/CONFIG_GRUB_IMAGES/d' "${HOME_PATH}/.config"
  echo -e "\nCONFIG_GRUB_IMAGES=y" >> "${HOME_PATH}/.config"
fi

if [[ `grep -c "CONFIG_TARGET_armvirt=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  sed -i 's/CONFIG_PACKAGE_luci-app-autoupdate=y/# CONFIG_PACKAGE_luci-app-autoupdate is not set/g' ${HOME_PATH}/.config
  export REGULAR_UPDATE="false"
  echo "REGULAR_UPDATE=false" >> ${GITHUB_ENV}
  sed -i '/CONFIG_PACKAGE_openssh-sftp-server/d' "${HOME_PATH}/.config"
  echo -e "\nCONFIG_PACKAGE_openssh-sftp-server=y" >> "${HOME_PATH}/.config"
fi

if [[ `grep -c "CONFIG_PACKAGE_odhcp6c=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  sed -i '/CONFIG_PACKAGE_odhcpd=y/d' "${HOME_PATH}/.config"
  sed -i '/CONFIG_PACKAGE_odhcpd_full_ext_cer_id=0/d' "${HOME_PATH}/.config"
fi

if [[ ! "${REGULAR_UPDATE}" == "true" ]] || [[ -z "${REPO_TOKEN}" ]]; then
  sed -i 's/CONFIG_PACKAGE_luci-app-autoupdate=y/# CONFIG_PACKAGE_luci-app-autoupdate is not set/g' ${HOME_PATH}/.config
fi

if [[ `grep -c "CONFIG_TARGET_ROOTFS_EXT4FS=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  PARTSIZE="$(egrep -o "CONFIG_TARGET_ROOTFS_PARTSIZE=[0-9]+" ${HOME_PATH}/.config |cut -f2 -d=)"
  if [[ "${PARTSIZE}" -lt "950" ]];then
    sed -i '/CONFIG_TARGET_ROOTFS_PARTSIZE/d' ${HOME_PATH}/.config
    echo -e "\nCONFIG_TARGET_ROOTFS_PARTSIZE=950" >> ${HOME_PATH}/.config
    echo "TIME r \"EXT4提示：请注意，您选择了ext4安装的固件格式,而检测到您的分配的固件系统分区过小\"" >> ${HOME_PATH}/CHONGTU
    echo "TIME y \"为避免编译出错,已自动帮您修改成950M\"" >> ${HOME_PATH}/CHONGTU
    echo "" >> ${HOME_PATH}/CHONGTU
  fi
fi
cd ${HOME_PATH}
./scripts/diffconfig.sh > ${GITHUB_WORKSPACE}/${CONFIG_FILE}
cp -Rf ${GITHUB_WORKSPACE}/${CONFIG_FILE} ${GITHUB_WORKSPACE}/config.txt
}


function Make_defconfig() {
echo "正在执行：识别源码编译为何机型"
export TARGET_BOARD="$(awk -F '[="]+' '/TARGET_BOARD/{print $2}' ${HOME_PATH}/.config)"
export TARGET_SUBTARGET="$(awk -F '[="]+' '/TARGET_SUBTARGET/{print $2}' ${HOME_PATH}/.config)"
if [[ `grep -c "CONFIG_TARGET_x86_64=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  export TARGET_PROFILE="x86-64"
elif [[ `grep -c "CONFIG_TARGET_x86=y" ${HOME_PATH}/.config` == '1' ]] && [[ `grep -c "CONFIG_TARGET_x86_64=y" ${HOME_PATH}/.config` == '0' ]]; then
  export TARGET_PROFILE="x86_32"
elif [[ `grep -c "CONFIG_TARGET.*DEVICE.*=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  export TARGET_PROFILE="$(egrep -o "CONFIG_TARGET.*DEVICE.*=y" ${HOME_PATH}/.config | sed -r 's/.*DEVICE_(.*)=y/\1/')"
else
  export TARGET_PROFILE="${TARGET_BOARD}"
fi
export FIRMWARE_PATH=${HOME_PATH}/bin/targets/${TARGET_BOARD}/${TARGET_SUBTARGET}
export TARGET_OPENWRT=openwrt/bin/targets/${TARGET_BOARD}/${TARGET_SUBTARGET}
echo "正在编译：${TARGET_PROFILE}"

if [[ "${SOURCE_CODE}" == "AMLOGIC" && "${AUTOMATIC_AMLOGIC}" == "true" ]]; then
  echo "PROMPT_TING=${amlogic_model}" >> ${GITHUB_ENV}
else
  echo "PROMPT_TING=${TARGET_PROFILE}" >> ${GITHUB_ENV}
fi

echo "TARGET_BOARD=${TARGET_BOARD}" >> ${GITHUB_ENV}
echo "TARGET_SUBTARGET=${TARGET_SUBTARGET}" >> ${GITHUB_ENV}
echo "TARGET_PROFILE=${TARGET_PROFILE}" >> ${GITHUB_ENV}
echo "FIRMWARE_PATH=${FIRMWARE_PATH}" >> ${GITHUB_ENV}

if [[ "${Delete_NotRequired}" == "1" ]]; then
  sed -i "s|^TARGET_|# TARGET_|g; s|# TARGET_DEVICES += ${TARGET_PROFILE}|TARGET_DEVICES += ${TARGET_PROFILE}|" ${HOME_PATH}/target/linux/${TARGET_BOARD}/image/Makefile
  echo "${HOME_PATH}/target/linux/${TARGET_BOARD}/image/Makefile"
fi

export patchverl="$(grep "KERNEL_PATCHVER" "${HOME_PATH}/target/linux/${TARGET_BOARD}/Makefile" |egrep -o "[0-9]+\.[0-9]+")"
export KERNEL_patc="patches-${Kernel_Patchver}"
if [[ ! "${Kernel_Patchver}" == "0" ]] && [[ -n "${Kernel_Patchver}" ]] && [[ -n "${patchverl}" ]]; then
  if [[ `ls -1 "${HOME_PATH}/target/linux/${TARGET_BOARD}" |grep -c "${KERNEL_patc}"` -eq '1' ]]; then
    sed -i "s/${patchverl}/${Kernel_Patchver}/g" ${HOME_PATH}/target/linux/${TARGET_BOARD}/Makefile
  else
    echo "TIME r \"没发现源码有[ ${Kernel_Patchver} ]内核存在，替换内核操作失败，保持默认内核[${patchverl}]继续编译\"" >> ${HOME_PATH}/CHONGTU
  fi
fi

if [[ ! "${Default_Theme}" == "0" ]] && [[ -n "${Default_Theme}" ]]; then
  export defaultt=CONFIG_PACKAGE_luci-theme-${Default_Theme}=y
  if [[ `grep -c "${defaultt}" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i '/mediaurlbase/d' "${FIN_PATH}"
    echo "
      uci set luci.main.mediaurlbase='/luci-static/${Default_Theme}'
      uci commit luci
    " >> "${FIN_PATH}"
  else
     echo "TIME r \"没有选择luci-theme-${Default_Theme}此主题,将${Default_Theme}设置成默认主题的操作失败\"" >> ${HOME_PATH}/CHONGTU
  fi
fi
}


function Diy_adguardhome() {
if [[ `grep -c "CONFIG_PACKAGE_luci-app-adguardhome=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  echo "正在执行：给adguardhome下载核心"
  if [[ `grep -c "CONFIG_ARCH=\"x86_64\"" ${HOME_PATH}/.config` -eq '1' ]]; then
    Arch="amd64"
    echo "X86_64"
  elif [[ `grep -c "CONFIG_ARCH=\"i386\"" ${HOME_PATH}/.config` -eq '1' ]]; then
    Arch="i386"
    echo "X86_32"
  elif [[ `grep -c "CONFIG_ARCH=\"aarch64\"" ${HOME_PATH}/.config` -eq '1' ]]; then
    Arch="arm64"
    echo "armv8"
  elif [[ `grep -c "CONFIG_ARCH=\"arm\"" ${HOME_PATH}/.config` -eq '1' ]] && [[ `grep -c "CONFIG_arm_v7=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    Arch="armv7"
    echo "armv7"
  else
    echo "This model does not support automatic core download"
  fi
	
  if [[ "${Arch}" =~ (amd64|i386|arm64|armv7) ]]; then
    downloader="curl -L -k --retry 2 --connect-timeout 20 -o"
    latest_ver="$($downloader - https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest 2>/dev/null|grep -E 'tag_name' |grep -E 'v[0-9.]+' -o 2>/dev/null)"
    wget -q https://github.com/AdguardTeam/AdGuardHome/releases/download/${latest_ver}/AdGuardHome_linux_${Arch}.tar.gz
    if [[ -f "AdGuardHome_linux_${Arch}.tar.gz" ]]; then
      tar -zxvf AdGuardHome_linux_${Arch}.tar.gz -C ${HOME_PATH}
      echo "核心下载成功"
    else
      echo "下载核心不成功"
    fi
    mkdir -p ${HOME_PATH}/files/usr/bin
    if [[ -f "${HOME_PATH}/AdGuardHome/AdGuardHome" ]]; then
      mv -f ${HOME_PATH}/AdGuardHome/AdGuardHome ${HOME_PATH}/files/usr/bin
      chmod 777 ${HOME_PATH}/files/usr/bin/AdGuardHome
      echo "解压核心包成功,完成增加AdGuardHome核心工作"
    else
      echo "解压核心包失败,没能增加AdGuardHome核心"
    fi
    rm -rf ${HOME_PATH}/{AdGuardHome_linux_${Arch}.tar.gz,AdGuardHome}
  fi
fi
}


function Diy_upgrade2() {
sed -i '/^#/d' ${FIN_PATH}
sed -i '/exit 0/d' "${FIN_PATH}"
echo -e "\nexit 0" >> ${FIN_PATH}
sed -i '/^#/d' ${ZZZ_PATH}
sed -i '/exit 0/d' "${ZZZ_PATH}"
echo -e "\nexit 0" >> ${ZZZ_PATH}

if [[ "${REGULAR_UPDATE}" == "true" ]]; then
  source ${BUILD_PATH}/upgrade.sh && Diy_Part2
fi
}


function Package_amlogic() {
echo "正在执行：打包N1和景晨系列固件"
# 下载上游仓库
cd ${GITHUB_WORKSPACE}
git clone --depth 1 https://github.com/ophub/amlogic-s9xxx-openwrt.git ${GITHUB_WORKSPACE}/amlogic
[ ! -d ${GITHUB_WORKSPACE}/amlogic/openwrt-armvirt ] && mkdir -p ${GITHUB_WORKSPACE}/amlogic/openwrt-armvirt
if [[ `ls -1 "${FIRMWARE_PATH}" |grep -c ".*default-rootfs.tar.gz"` == '1' ]]; then
  cp -Rf ${FIRMWARE_PATH}/*default-rootfs.tar.gz ${GITHUB_WORKSPACE}/amlogic/openwrt-armvirt/openwrt-armvirt-64-default-rootfs.tar.gz && sync
else
  armvirtargz="$(ls -1 "${FIRMWARE_PATH}" |grep ".*tar.gz" |awk 'END {print}')"
  cp -Rf ${FIRMWARE_PATH}/${armvirtargz} ${GITHUB_WORKSPACE}/amlogic/openwrt-armvirt/openwrt-armvirt-64-default-rootfs.tar.gz && sync
fi

# 开始打包
cd ${GITHUB_WORKSPACE}/amlogic
sudo chmod +x make
sudo ./make -d -b ${amlogic_model} -k ${amlogic_kernel} -s ${rootfs_size}
sudo mv -f ${GITHUB_WORKSPACE}/amlogic/out/* ${FIRMWARE_PATH}/ && sync
sudo rm -rf ${GITHUB_WORKSPACE}/amlogic
}


function Diy_upgrade3() {
if [ "${REGULAR_UPDATE}" == "true" ]; then
  cp -Rf ${FIRMWARE_PATH} ${HOME_PATH}/upgrade
  source ${BUILD_PATH}/upgrade.sh && Diy_Part3
fi
}


function Diy_organize() {
cd ${FIRMWARE_PATH}
mkdir -p ipk
cp -rf $(find ${HOME_PATH}/bin/packages/ -type f -name "*.ipk") ipk/ && sync
sudo tar -czf ipk.tar.gz ipk && sync && sudo rm -rf ipk
if [[ `ls -1 | grep -c "immortalwrt"` -ge '1' ]]; then
  rename -v "s/^immortalwrt/openwrt/" *
fi
for X in $(cat "${CLEAR_PATH}" |sed 's/rm -rf//g' |sed 's/rm -fr//g' |sed 's/\r//' |sed 's/ //g' |cut -d '-' -f4- |sed '/^$/d' |sed 's/^/*/g' |sed 's/$/*/g'); do
   rm -rf "${X}"
done

if [[ "${SOURCE_CODE}" == "AMLOGIC" ]]; then
  rename -v "s/^openwrt/openwrt-amlogic/" *
else
  rename -v "s/^openwrt/${Gujian_Date}-${SOURCE}/" *
fi

sudo rm -rf "${CLEAR_PATH}"

cd ${HOME_PATH}
# 发布用的update_log.txt
if [ "${UPLOAD_RELEASE}" == "true" ]; then
  echo "#### $(date +"%Y年%m月%d号-%H点%M分")" > ${GITHUB_WORKSPACE}/update_log.txt
fi
if [ "${REGULAR_UPDATE}" == "true" ]; then
  echo "#### $(date +"%Y年%m月%d号-%H点%M分")" > ${GITHUB_WORKSPACE}/AutoUpdate_log.txt
fi
}


function Diy_firmware() {
echo "正在执行：整理固件,您不想要啥就删啥,删删删"
Diy_upgrade3
Diy_organize
}


function Diy_xinxi() {
Plug_in="$(grep 'CONFIG_PACKAGE_luci-app' ${HOME_PATH}/.config && grep 'CONFIG_PACKAGE_luci-theme' ${HOME_PATH}/.config)"
Plug_in2="$(echo "${Plug_in}" | grep -v '^#' |sed '/INCLUDE/d' |sed '/=m/d' |sed '/_Transparent_Proxy/d' |sed '/qbittorrent_static/d' |sed 's/CONFIG_PACKAGE_//g' |sed 's/=y//g' |sed 's/^/、/g' |sed 's/$/\"/g' |awk '$0=NR$0' |sed 's/^/TIME g \"       /g')"
echo "${Plug_in2}" >Plug-in
sed -i '/luci-app-qbittorrent-simple_dynamic/d' Plug-in > /dev/null 2>&1

if [[ `grep -c "# CONFIG_GRUB_EFI_IMAGES is not set" ${HOME_PATH}/.config` -eq '1' ]]; then
  export EFI_NO="1"
fi


export KERNEL_PATCH="$(grep "KERNEL_PATCHVER" "${HOME_PATH}/target/linux/${TARGET_BOARD}/Makefile" |egrep -o "[0-9]+\.[0-9]+")"
export KERNEL_patc="kernel-${KERNEL_PATCH}"
if [[ `ls -1 "${HOME_PATH}/include" |grep -c "${KERNEL_patc}"` -eq '1' ]]; then
  export LINUX_KERNEL="$(grep "LINUX_KERNEL_HASH" "${HOME_PATH}/include/${KERNEL_patc}" |egrep -o "[0-9]+\.[0-9]+\.[0-9]+")"
  [[ -z ${LINUX_KERNEL} ]] && export LINUX_KERNEL="nono"
else
  export LINUX_KERNEL="$(grep "LINUX_KERNEL_HASH" "${HOME_PATH}/include/kernel-version.mk" |egrep -o "${KERNEL_PATCH}\.[0-9]+")"
  [[ -z ${LINUX_KERNEL} ]] && export LINUX_KERNEL="nono"
fi

echo
TIME b "编译源码: ${SOURCE}"
TIME b "源码链接: ${REPO_URL}"
TIME b "源码分支: ${REPO_BRANCH}"
TIME b "源码作者: ${MAINTAIN}"
TIME b "Luci版本: ${LUCI_EDITION}"
if [[ "${SOURCE_CODE}" == "AMLOGIC" ]]; then
  TIME b "编译机型: 晶晨系列"
  if [[ "${AUTOMATIC_AMLOGIC}" == "true" ]]; then
     TIME g "打包机型: ${amlogic_model}"
     TIME g "打包内核: ${amlogic_kernel}"
     TIME g "分区大小: ${rootfs_size}"
  else
     TIME b "内核版本: ${LINUX_KERNEL}"
     TIME r "自动打包: 没开启自动打包设置"
  fi
else
  TIME b "内核版本: ${LINUX_KERNEL}"
  TIME b "编译机型: ${TARGET_PROFILE}"
fi
TIME b "固件作者: ${Author}"
TIME b "仓库地址: ${Github}"
TIME b "启动编号: #${Run_number}（${Library}仓库第${Run_number}次启动[${Run_workflow}]工作流程）"
TIME b "编译时间: ${Compte_Date}"
if [[ "${SOURCE_CODE}" == "AMLOGIC" && "${AUTOMATIC_AMLOGIC}" == "true" ]]; then
  TIME g "友情提示：您当前使用【${matrixtarget}】文件夹编译【${amlogic_model}】固件"
else
  TIME g "友情提示：您当前使用【${matrixtarget}】文件夹编译【${TARGET_PROFILE}】固件"
fi
echo
echo
if [[ ${UPLOAD_FIRMWARE} == "true" ]]; then
  TIME y "上传固件在github actions: 开启"
else
  TIME r "上传固件在github actions: 关闭"
fi
if [[ ${UPLOAD_CONFIG} == "true" ]]; then
  TIME y "上传[.config]配置文件: 开启"
else
  TIME r "上传[.config]配置文件: 关闭"
fi
if [[ ${UPLOAD_BIN_DIR} == "true" ]]; then
  TIME y "上传BIN文件夹(固件+IPK): 开启"
else
  TIME r "上传BIN文件夹(固件+IPK): 关闭"
fi
if [[ ${UPLOAD_WETRANSFER} == "true" ]]; then
  TIME y "上传固件至【WETRANSFER】: 开启"
else
  TIME r "上传固件至【WETRANSFER】: 关闭"
fi
if [[ ${UPLOAD_RELEASE} == "true" ]]; then
  TIME y "发布固件: 开启"
else
  TIME r "发布固件: 关闭"
fi
if [[ ${SERVERCHAN_SCKEY} == "true" ]]; then
  TIME y "微信/电报通知: 开启"
else
  TIME r "微信/电报通知: 关闭"
fi
if [[ ${BY_INFORMATION} == "true" ]]; then
  TIME y "编译信息显示: 开启"
fi
if [[ ${REGULAR_UPDATE} == "true" ]]; then
  TIME y "把定时自动更新插件编译进固件: 开启"
else
  TIME r "把定时自动更新插件编译进固件: 关闭"
fi

if [[ "${REGULAR_UPDATE}" == "true" ]] && [[ -z "${REPO_TOKEN}" ]]; then
  echo
  echo
  TIME r "您虽然开启了编译在线更新固件操作,但是您的[REPO_TOKEN]密匙为空,"
  TIME r "无法将固件发布至云端,已为您自动关闭了编译在线更新固件"
  echo
elif [[ "${REGULAR_UPDATE}" == "true" ]] && [[ -n "${REPO_TOKEN}" ]]; then
  echo
  TIME l "定时自动更新信息"
  TIME z "插件版本: ${AutoUpdate_Version}"
  if [[ ${Firmware_SFX} == ".img.gz" ]]; then
    TIME b "传统固件: ${Legacy_Firmware}"
    [[ ! "${EFI_NO}" == "1" ]] && TIME b "UEFI固件: ${UEFI_Firmware}"
    TIME b "固件后缀: ${Firmware_SFX}"
  else
    TIME b "固件名称: ${Up_Firmware}"
    TIME b "固件后缀: ${Firmware_SFX}"
  fi
  TIME b "固件版本: ${Openwrt_Version}"
  TIME b "云端路径: ${Github_Release}"
  TIME g "《编译成功后，会自动把固件发布到指定地址，然后才会生成云端路径》"
  TIME g "《普通的那个发布固件跟云端的发布路径是两码事，如果你不需要普通发布的可以不用打开发布功能》"
  TIME g "修改IP、DNS、网关或者在线更新，请输入命令：openwrt"
  echo
else
  echo
fi
echo
TIME z " 系统空间      类型   总数  已用  可用 使用率"
cd ../ && df -hT $PWD && cd ${HOME_PATH}
echo
echo

if [[ -s "${HOME_PATH}/CHONGTU" ]]; then
  echo
  echo
  TIME b "			错误信息"
  echo
  chmod -R +x ${HOME_PATH}/CHONGTU
  source ${HOME_PATH}/CHONGTU
fi
rm -rf ${HOME_PATH}/CHONGTU
}

function Diy_menu5() {
Diy_prevent
Make_defconfig
Diy_adguardhome
Diy_upgrade2
}

function Diy_menu4() {
Diy_files
Diy_part_sh
Diy_Language
Diy_feeds
Diy_IPv6helper
}

function Diy_menu3() {
Diy_wenjian
Diy_clean
Diy_${SOURCE_CODE}
Diy_distrib
Diy_chajianyuan
Diy_upgrade1
}

function Diy_menu2() {
Diy_Notice
}

function Diy_menu1() {
Diy_variable
Diy_settings
}
