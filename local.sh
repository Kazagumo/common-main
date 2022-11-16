#!/bin/bash

GITHUB_WORKSPACE="$PWD"
GITHUB_ENV="${GITHUB_WORKSPACE}/GITHUB_ENV"

echo '#!/bin/bash' > ${GITHUB_ENV}
chmod +x ${GITHUB_ENV}

if [[ ! -d "${GITHUB_WORKSPACE}/build" ]]; then
  svn export https://github.com/281677160/autobuild/trunk/build ${GITHUB_WORKSPACE}/build
  git clone -b main --depth 1 https://github.com/281677160/common-main ${GITHUB_WORKSPACE}/build/common
else
  rm -rf ${GITHUB_WORKSPACE}/build/common && git clone -b main --depth 1 https://github.com/281677160/common-main ${GITHUB_WORKSPACE}/build/common
fi

FOLDER_NAME="Official"

mv -f build/common/*.sh build/${FOLDER_NAME}/
sudo chmod -R +x build
source build/${FOLDER_NAME}/common.sh && Diy_menu1
source ${GITHUB_ENV}

source ${GITHUB_WORKSPACE}/build/${FOLDER_NAME}/common.sh && Diy_update

rm -rf ${HOME_PATH}
git clone -b "${REPO_BRANCH}" --single-branch "${REPO_URL}" ${HOME_PATH}
source ${GITHUB_WORKSPACE}/build/${FOLDER_NAME}/common.sh && Diy_checkout

mv -f ${GITHUB_WORKSPACE}/build ${HOME_PATH}/build

cd ${HOME_PATH}
source build/${FOLDER_NAME}/common.sh && Diy_menu2
source ${BUILD_PATH}/common.sh && Diy_menu3
source $BUILD_PATH/$DIY_PART_SH
source build/${FOLDER_NAME}/common.sh && Diy_Publicarea
source ${BUILD_PATH}/common.sh && Diy_menu4

make menuconfig

cd ${HOME_PATH}
source ${BUILD_PATH}/common.sh && Diy_menu5
source ${BUILD_PATH}/common.sh && Diy_xinxi

cd ${HOME_PATH}
make defconfig
make download -j8
find dl -size -1024c -exec ls -l {} \;
find dl -size -1024c -exec rm -f {} \;

cd ${HOME_PATH}
make -j$(($(nproc) + 1)) || make -j1 V=s

cd ${HOME_PATH}
source ${BUILD_PATH}/common.sh && Diy_firmware


