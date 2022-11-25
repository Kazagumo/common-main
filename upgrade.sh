#!/bin/bash
# https://github.com/Hyy2001X/AutoBuild-Actions
# AutoBuild Module by Hyy2001
# AutoBuild Functions


function Diy_Part1() {
  if [[ -f "$BUILD_PATH/AutoUpdate.sh" ]]; then
    echo "正在执行：给源码增加定时更新固件插件和设置插件和ttyd成默认自选"
    find . -name 'luci-app-autoupdate' | xargs -i rm -rf {}
    git clone -b ceshi https://github.com/281677160/luci-app-autoupdate $HOME_PATH/package/luci-app-autoupdate
    [[ ! -d "$FILES_PATH/usr/bin" ]] && mkdir $FILES_PATH/usr/bin
    cp $BUILD_PATH/AutoUpdate.sh $FILES_PATH/usr/bin/AutoUpdate
    cp $BUILD_PATH/replace.sh $FILES_PATH/etc/replace
    sudo chmod +x $FILES_PATH/etc/replace
    sudo chmod +x $FILES_PATH/usr/bin/AutoUpdate
    if [[ `grep -c "luci-app-autoupdate" ${HOME_PATH}/include/target.mk` -eq '0' ]]; then
      sed -i 's?DEFAULT_PACKAGES:=?DEFAULT_PACKAGES:=luci-app-autoupdate luci-app-ttyd ?g' ${HOME_PATH}/include/target.mk
    fi
    [[ -d $HOME_PATH/package/luci-app-autoupdate ]] && echo "增加定时更新固件的插件成功"
  else
    echo "没发现AutoUpdate.sh文件存在，不能增加在线升级固件程序"
  fi
}

function GET_TARGET_INFO() {
	
	In_Firmware_Info="$FILES_PATH/etc/openwrt_update"
	Github_Release="${GITHUB_LINK}/releases/tag/AutoUpdate"
	Openwrt_Version="${SOURCE}-${TARGET_PROFILE}-${Upgrade_Date}"
	Github_API1="https://api.github.com/repos/${GIT_REPOSITORY}/releases/tags/AutoUpdate"
	Github_API2="https://download.fastgit.org/${GIT_REPOSITORY}/releases/download/AutoUpdate/zzz_api"
	API_PATH="/tmp/Downloads/zzz_api"
	Release_download="https://github.com/${GIT_REPOSITORY}/releases/download/AutoUpdate"
	LOCAL_FIRMW="${LUCI_EDITION}-${SOURCE}"
	CLOUD_CHAZHAO="${LUCI_EDITION}-${SOURCE}-${TARGET_PROFILE}"
	echo "Openwrt_Version=${Openwrt_Version}" >> ${GITHUB_ENV}
	echo "Github_Release=${Github_Release}" >> ${GITHUB_ENV}
	
	
	case "${TARGET_BOARD}" in
	ramips | reltek | ath* | ipq* | bcm47xx | bmips | kirkwood | mediatek)
		export Firmware_SFX=".bin"
		export AutoBuild_Firmware="${LUCI_EDITION}-${Openwrt_Version}-sysupgrade"
	;;
	x86)
		export Firmware_SFX=".img.gz"
		export UEFI_Firmware="${LUCI_EDITION}-${Openwrt_Version}-uefi"
		export Legacy_Firmware="${LUCI_EDITION}-${Openwrt_Version}-legacy"
	;;
	rockchip | bcm27xx | mxs | sunxi | zynq)
		export Firmware_SFX=".img.gz"
		export AutoBuild_Firmware="${LUCI_EDITION}-${Openwrt_Version}-sysupgrade"
	;;
	mvebu)
		case "${TARGET_SUBTARGET}" in
		cortexa53 | cortexa72)
			export Firmware_SFX=".img.gz"
			export AutoBuild_Firmware="${LUCI_EDITION}-${Openwrt_Version}-sysupgrade"
		;;
		esac
	;;
	bcm53xx)
		export Firmware_SFX=".trx"
		export AutoBuild_Firmware="${LUCI_EDITION}-${Openwrt_Version}-sysupgrade"
	;;
	octeon | oxnas | pistachio)
		export Firmware_SFX=".tar"
		export AutoBuild_Firmware="${LUCI_EDITION}-${Openwrt_Version}-sysupgrade"
	;;
	*)
		export Firmware_SFX=".bin"
		export AutoBuild_Firmware="${LUCI_EDITION}-${Openwrt_Version}-sysupgrade"
	;;
	esac
	
	
	if [[ -f "$FILES_PATH/usr/bin/AutoUpdate" ]]; then
	  export AutoUpdate_Version=$(egrep -o "Version=V[0-9]\.[0-9]" $FILES_PATH/usr/bin/AutoUpdate |cut -d "=" -f2 | sed 's/^.//g')
	else
	  export AutoUpdate_Version="7.1"
	fi
	
	echo "Legac_Firmware=${Legacy_Firmware}${Firmware_SFX}" >> ${GITHUB_ENV}
	echo "EFI_Firmware=${UEFI_Firmware}${Firmware_SFX}" >> ${GITHUB_ENV}
	echo "Up_Firmware=${AutoBuild_Firmware}${Firmware_SFX}" >> ${GITHUB_ENV}
	echo "Firmware_SFX=${Firmware_SFX}" >> ${GITHUB_ENV}
	echo "AutoUpdate_Version=${AutoUpdate_Version}" >> ${GITHUB_ENV}

}

function Diy_Part2() {
GET_TARGET_INFO
touch ${In_Firmware_Info}
sudo chmod +x ${In_Firmware_Info}
cat >${In_Firmware_Info} <<-EOF
GITHUB_LINK=${GITHUB_LINK}
GIT_REPOSITORY=${GIT_REPOSITORY}
SOURCE=${SOURCE}
LUCI_EDITION=${LUCI_EDITION}
DEFAULT_Device=${TARGET_PROFILE}
Firmware_SFX=${Firmware_SFX}
TARGET_BOARD=${TARGET_BOARD}
CURRENT_Version=${Openwrt_Version}
CLOUD_CHAZHAO=${CLOUD_CHAZHAO}
Download_Path=/tmp/Downloads
Version=${AutoUpdate_Version}
API_PATH=${API_PATH}
Github_API1=${Github_API1}
Github_API2=${Github_API2}
Github_Release=${Github_Release}
Release_download=${Release_download}
EOF
}

function Diy_Part3() {
	GET_TARGET_INFO
	BIN_PATH="${HOME_PATH}/bin/Firmware"
	echo "BIN_PATH=${BIN_PATH}" >> ${GITHUB_ENV}
	[[ ! -d "${BIN_PATH}" ]] && mkdir -p ${BIN_PATH} || rm -rf ${BIN_PATH}/*
	
	cd "${FIRMWARE_PATH}"
	if [[ `ls -1 |grep -c ".img"` -ge '1' ]] && [[ `ls -1 |grep -c ".img.gz"` == '0' ]]; then
		gzip *.img
	fi
	
	case "${TARGET_BOARD}" in
	x86)
		EFI_ZHONGZHUAN="$(ls -1 |egrep .*x86.*squashfs.*efi.*img.gz)"
		if [[ -n "${EFI_ZHONGZHUAN}" ]]; then
		  EFIMD5="$(md5sum ${EFI_ZHONGZHUAN} | cut -c1-3)$(sha256sum ${EFI_ZHONGZHUAN} | cut -c1-3)"
		  cp ${EFI_ZHONGZHUAN} ${BIN_PATH}/${UEFI_Firmware}-${EFIMD5}${Firmware_SFX}
		else
		  echo "没找到uefi固件"
		fi
		
		LEGA_ZHONGZHUAN="$(ls -1 |egrep .*x86.*squashfs.*img.gz |grep -v rootfs |grep -v efi)"
		if [[ -n "${LEGA_ZHONGZHUAN}" ]]; then
		  LEGAMD5="$(md5sum ${LEGA_ZHONGZHUAN} | cut -c1-3)$(sha256sum ${LEGA_ZHONGZHUAN} | cut -c1-3)"
		  cp ${LEGA_ZHONGZHUAN} ${BIN_PATH}/${Legacy_Firmware}-${LEGAMD5}${Firmware_SFX}
		else
		  echo "没找到legacy固件"
		fi
	;;
	*)
		UP_ZHONGZHUAN="$(ls -1 |egrep .*${TARGET_PROFILE}.*squashfs.*${Firmware_SFX} |grep -v rootfs)"
		if [[ -n "${UP_ZHONGZHUAN}" ]]; then
		  MD5="$(md5sum ${UP_ZHONGZHUAN} | cut -c1-3)$(sha256sum ${UP_ZHONGZHUAN} | cut -c1-3)"
		  cp ${UP_ZHONGZHUAN} ${BIN_PATH}/${AutoBuild_Firmware}-${MD5}${Firmware_SFX}
		fi
		if [[ -z "${UP_ZHONGZHUAN}" ]]; then
		  UP_ZHONGZHUAN="$(ls -1 |egrep .*${TARGET_PROFILE}.*sysupgrade${Firmware_SFX} |grep -v rootfs)"
		  MD5="$(md5sum ${UP_ZHONGZHUAN} | cut -c1-3)$(sha256sum ${UP_ZHONGZHUAN} | cut -c1-3)"
		  cp ${UP_ZHONGZHUAN} ${BIN_PATH}/${AutoBuild_Firmware}-${MD5}${Firmware_SFX}
		else
		  echo "没找到固件"
		fi
	;;
	esac
}
