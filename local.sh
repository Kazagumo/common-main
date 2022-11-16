#!/bin/bash

GITHUB_WORKSPACE="$PWD"
GITHUB_ENV="${GITHUB_WORKSPACE}/GITHUB_ENV"

echo '#!/bin/bash' > ${GITHUB_ENV}
chmod +x ${GITHUB_ENV}

FOLDER_NAME="Official"

function Bendi_MainProgram() {
echo "下载编译文件"
rm -rf ${GITHUB_WORKSPACE}/build
svn export https://github.com/281677160/autobuild/trunk/build ${GITHUB_WORKSPACE}/build
git clone -b main --depth 1 https://github.com/281677160/common-main ${GITHUB_WORKSPACE}/build/common
mv -f build/common/*.sh build/${FOLDER_NAME}/
sudo chmod -R +x build
}

function Bendi_Variable() {
echo "读取变量"
source build/${FOLDER_NAME}/common.sh && Diy_menu1
source ${GITHUB_ENV}
source ${GITHUB_WORKSPACE}/build/${FOLDER_NAME}/common.sh && Diy_update
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


