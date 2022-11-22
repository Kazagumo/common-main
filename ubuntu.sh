#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-only
#
# Copyright (C) ImmortalWrt.org

function bendi_notice(){
if [[ -n "${BENDI_VERSION}" ]]; then
  clear
  echo
  echo
  echo -e "\033[32m 首次使用本脚本，需要先安装依赖，10秒后开始安装依赖  \033[0m"
  echo
  echo -e "\033[33m 如果出现 YES OR NO 选择界面，直接按回车即可  \033[0m"
  sleep 10
  echo
  echo
  INS="sudo apt-get"
else
  INS="sudo -E apt-get -qq"
  if [[ "${SOURCE_CODE}" == "AMLOGIC" ]]; then
    docker rmi `docker images -q`
    ${INS} remove -y --purge azure-cli ghc* zulu* llvm* firefox google* powershell openjdk* msodbcsql17 mongodb* moby* snapd* mysql*
    sudo rm -rf /etc/apt/sources.list.d/* /usr/share/dotnet /usr/local/lib/android /usr/lib/jvm /opt/ghc /swapfile
  fi
fi
}

function install_mustrelyon(){
# 安装大雕列出的编译openwrt依赖
${INS} update -y
${INS} full-upgrade -y
${INS} install -y ack antlr3 aria2 asciidoc autoconf automake autopoint binutils bison build-essential \
bzip2 ccache cmake cpio curl device-tree-compiler fastjar flex gawk gettext gcc-multilib g++-multilib \
git gperf haveged help2man intltool libc6-dev-i386 libelf-dev libglib2.0-dev libgmp3-dev libltdl-dev \
libmpc-dev libmpfr-dev libncurses5-dev libncursesw5-dev libreadline-dev libssl-dev libtool lrzsz \
mkisofs msmtp nano ninja-build p7zip p7zip-full patch pkgconf python2.7 python3 python3-pip libpython3-dev qemu-utils \
rsync scons squashfs-tools subversion swig texinfo uglifyjs upx-ucl unzip vim wget xmlto xxd zlib1g-dev
}

function ophub_amlogic-s9xxx(){
# 安装我仓库需要的依赖
${INS} install -y rename pigz
# 安装打包N1需要用到的依赖
${INS} install -y $(curl -fsSL https://is.gd/depend_ubuntu2204_openwrt)
}

function update_apt_source(){
# 安装nodejs 16 和yarn
${INS} install -y apt-transport-https gnupg2
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
${INS} install -y nodejs gcc g++ make
${INS} update -y
${INS} install -y yarn

node --version
yarn --version
}

function install_dependencies(){
svn co -r96154 "https://github.com/openwrt/openwrt/trunk/tools/padjffs2/src" "padjffs2"
pushd "padjffs2"
make
rm -rf "/usr/bin/padjffs2"
cp -fp "padjffs2" "/usr/bin/padjffs2"
popd

sudo rm -rf padjffs2

svn co -r19250 "https://github.com/openwrt/luci/trunk/modules/luci-base/src" "po2lmo"
pushd "po2lmo"
make po2lmo
rm -rf "/usr/bin/po2lmo"
cp -fp "po2lmo" "/usr/bin/po2lmo"
popd

sudo rm -rf po2lmo

curl -fL "https://build-scripts.immortalwrt.eu.org/modify-firmware.sh" -o "/usr/bin/modify-firmware"
chmod 0755 "/usr/bin/modify-firmware"
popd

${INS} autoremove -y --purge
${INS} clean
}

function main(){
	bendi_notice
	install_mustrelyon
	ophub_amlogic-s9xxx
	update_apt_source
	install_dependencies
}

main
