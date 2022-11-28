#!/bin/bash
# https://github.com/Hyy2001X/AutoBuild-Actions
# AutoBuild Module by Hyy2001
# AutoBuild Functions


function Diy_Part1() {
	find . -name 'luci-app-autoupdate' | xargs -i rm -rf {}
	echo "正在执行：给源码增加定时更新固件插件和设置插件和ttyd成默认自选"
	git clone -b ceshi https://github.com/281677160/luci-app-autoupdate $HOME_PATH/package/luci-app-autoupdate
	if [[ `grep -c "luci-app-autoupdate" ${HOME_PATH}/include/target.mk` -eq '0' ]]; then
		sed -i 's?DEFAULT_PACKAGES:=?DEFAULT_PACKAGES:=luci-app-autoupdate luci-app-ttyd ?g' ${HOME_PATH}/include/target.mk
	fi
	if [[ -d "$HOME_PATH/package/luci-app-autoupdate" ]]; then
		echo "增加定时更新固件的插件成功"
	else
		echo "插件源码下载失败"
	fi
}


function Diy_Part2() {
	export In_Firmware_Info="$FILES_PATH/etc/openwrt_update"
	export Github_Release="${GITHUB_LINK}/releases/tag/${TARGET_BOARD}"
	export Openwrt_Version="${SOURCE}-${TARGET_PROFILE}-${Upgrade_Date}"
	export Github_API1="https://api.github.com/repos/${GIT_REPOSITORY}/releases/tags/${TARGET_BOARD}"
	export Github_API2="https://ghproxy.com/https://github.com/${GIT_REPOSITORY}/releases/download/${TARGET_BOARD}/zzz_api"
	export API_PATH="/tmp/Downloads/zzz_api"
	export Release_download="${GITHUB_LINK}/releases/download/${TARGET_BOARD}"
	export LOCAL_FIRMW="${LUCI_EDITION}-${SOURCE}"
	export CLOUD_CHAZHAO="${LUCI_EDITION}-${SOURCE}-${TARGET_PROFILE}"
	
	
	case "${TARGET_BOARD}" in
	ramips | reltek | ath* | ipq* | bcm47xx | bmips | kirkwood | mediatek)
		export Firmware_SFX=".bin"
		export AutoBuild_Firmware="${LUCI_EDITION}-${Openwrt_Version}-sysupgrade"
	;;
	x86)
		export Firmware_SFX=".img.gz"
		export AutoBuild_Uefi="${LUCI_EDITION}-${Openwrt_Version}-uefi"
		export AutoBuild_Legacy="${LUCI_EDITION}-${Openwrt_Version}-legacy"
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
	
	if [[ "${TARGET_BOARD}" == "x86" ]]; then
	  echo "AutoBuild_Uefi=${AutoBuild_Uefi}" >> ${GITHUB_ENV}
	  echo "AutoBuild_Legacy=${AutoBuild_Legacy}" >> ${GITHUB_ENV}
	else
	  echo "AutoBuild_Firmware=${AutoBuild_Firmware}" >> ${GITHUB_ENV}
	fi
	
	echo "Firmware_SFX=${Firmware_SFX}" >> ${GITHUB_ENV}
	echo "AutoUpdate_Version=${AutoUpdate_Version}" >> ${GITHUB_ENV}
	echo "Openwrt_Version=${Openwrt_Version}" >> ${GITHUB_ENV}
	echo "Github_Release=${Github_Release}" >> ${GITHUB_ENV}


cat >"${In_Firmware_Info}" <<-EOF
GITHUB_LINK=${GITHUB_LINK}
CURRENT_Version=${Openwrt_Version}
SOURCE="${SOURCE}"
LUCI_EDITION="${LUCI_EDITION}"
DEFAULT_Device="${TARGET_PROFILE}"
Firmware_SFX="${Firmware_SFX}"
TARGET_BOARD="${TARGET_BOARD}"
CLOUD_CHAZHAO="${CLOUD_CHAZHAO}"
Download_Path="/tmp/Downloads"
Version="${AutoUpdate_Version}"
API_PATH="${API_PATH}"
Github_API1="${Github_API1}"
Github_API2="${Github_API2}"
Github_Release="${Github_Release}"
Release_download="${Release_download}"
EOF
	bash <(curl -fsSL https://raw.githubusercontent.com/281677160/common-main/main/autoupdate/replacebianliang.sh)
	sudo chmod +x ${In_Firmware_Info}
}

function Diy_Part3() {
	echo "1"
	BIN_PATH="${HOME_PATH}/bin/Firmware"
	echo "2"
	echo "BIN_PATH=${BIN_PATH}" >> ${GITHUB_ENV}
	echo "3"
	[[ ! -d "${BIN_PATH}" ]] && mkdir -p "${BIN_PATH}" || rm -rf "${BIN_PATH}"/*
	echo "4"
	cd "${FIRMWARE_PATH}"
	if [[ `ls -1 |grep -c ".img"` -ge '1' ]] && [[ `ls -1 |grep -c ".img.gz"` -eq '0' ]]; then
		gzip *.img
	fi
	echo "5"
	case "${TARGET_BOARD}" in
	x86)
		echo "6"
		EFI_ZHONGZHUAN="$(ls -1 |egrep .*x86.*squashfs.*efi.*img.gz)"
		echo "看看1固件信息，${EFI_ZHONGZHUAN}"
		if [[ -f "${EFI_ZHONGZHUAN}" ]]; then
		  EFIMD5="$(md5sum ${EFI_ZHONGZHUAN} |cut -c1-3)$(sha256sum ${EFI_ZHONGZHUAN} |cut -c1-3)"
		  echo "看看1MD5信息，${EFIMD5}"
		  cp -Rf "${EFI_ZHONGZHUAN}" "${BIN_PATH}/${AutoBuild_Uefi}-${EFIMD5}${Firmware_SFX}"
		  if [[ -f "${BIN_PATH}/${AutoBuild_Uefi}-${EFIMD5}${Firmware_SFX}" ]]; then
		    echo "固件到了 ${BIN_PATH}/${AutoBuild_Uefi}-${EFIMD5}${Firmware_SFX}?"
		    echo "既然没固件 ${BIN_PATH}/${AutoBuild_Uefi}-${EFIMD5}${Firmware_SFX}?"
		  else
		    echo "固件不能复制么?那我用中国移动看看"
		    mv -f "${EFI_ZHONGZHUAN}" "${BIN_PATH}/${AutoBuild_Uefi}-${EFIMD5}${Firmware_SFX}"
		    if [[ -f "${BIN_PATH}/${AutoBuild_Uefi}-${EFIMD5}${Firmware_SFX}" ]]; then
		      echo "中国移动果然行"
		    else
		      echo "中国移动也不行啊"
		    fi
		  fi
		else
		  echo "没找到uefi固件"
		fi
		
		LEGA_ZHONGZHUAN="$(ls -1 |egrep .*x86.*squashfs.*img.gz |grep -v rootfs |grep -v efi)"
		echo "看看2固件信息，${EFI_ZHONGZHUAN}"
		if [[ -f "${LEGA_ZHONGZHUAN}" ]]; then
		  LEGAMD5="$(md5sum ${LEGA_ZHONGZHUAN} |cut -c1-3)$(sha256sum ${LEGA_ZHONGZHUAN} |cut -c1-3)"
		  echo "看看2MD5信息，${LEGAMD5}"
		  cp -Rf "${LEGA_ZHONGZHUAN}" "${BIN_PATH}/${AutoBuild_Legacy}-${LEGAMD5}${Firmware_SFX}"
		  if [[ -f "${BIN_PATH}/${AutoBuild_Legacy}-${LEGAMD5}${Firmware_SFX}" ]]; then
		    echo "固件到了 ${BIN_PATH}/${AutoBuild_Legacy}-${LEGAMD5}${Firmware_SFX}?"
		  else
		    echo "既然没固件 ${BIN_PATH}/${AutoBuild_Legacy}-${LEGAMD5}${Firmware_SFX}?"
		    echo "固件不能复制么?那我用中国移动看看"
		    mv -f "${LEGA_ZHONGZHUAN}" "${BIN_PATH}/${AutoBuild_Legacy}-${LEGAMD5}${Firmware_SFX}"
		    if [[ -f "${BIN_PATH}/${AutoBuild_Legacy}-${LEGAMD5}${Firmware_SFX}" ]]; then
		      echo "中国移动果然行"
		    else
		      echo "中国移动也不行啊"
		    fi
		  fi
		else
		  echo "没找到legacy固件"
		fi
	;;
	*)
		UP_ZHONGZHUAN="$(ls -1 |egrep .*${TARGET_PROFILE}.*sysupgrade${Firmware_SFX} |grep -v rootfs |grep -v ext4  |grep -v factory)"
		if [[ ! -f "${UP_ZHONGZHUAN}" ]]; then
		  UP_ZHONGZHUAN="$(ls -1 |egrep .*${TARGET_PROFILE}.*squashfs.*${Firmware_SFX} |grep -v rootfs |grep -v ext4  |grep -v factory)"
		fi
		if [[ -f "${UP_ZHONGZHUAN}" ]]; then
		  MD5="$(md5sum ${UP_ZHONGZHUAN} | cut -c1-3)$(sha256sum ${UP_ZHONGZHUAN} | cut -c1-3)"
		  cp -Rf "${UP_ZHONGZHUAN}" "${BIN_PATH}/${AutoBuild_Firmware}-${MD5}${Firmware_SFX}"
		else
		  echo "没找到固件"
		fi
	;;
	esac
	cd ${HOME_PATH}
}
