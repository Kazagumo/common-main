for X in $(grep -Eo 'target: \[.*\]' -rl "/home/danshui/repogx/.github/workflows"); do
aa="$(grep 'target: \[.*\]' "${X}" |sed 's/^[ ]*//g' |grep -v '^#' | sed -r 's/target: \[(.*)\]/\1/')"
yml_name1="$(grep 'name:' "${X}"  |grep -v '^#' |awk 'NR==1')"
TARGE2="target: \\[${aa}\\]"
if [[ -d "repogx/build/${aa}" ]]; then
SOURCE_CODE1="$(grep 'SOURCE_CODE=' "repogx/build/${aa}/settings.ini" | cut -d '"' -f2)"
fi
if [[ "${SOURCE_CODE1}" == "AMLOGIC" ]]; then
  cp -Rf ${GITHUB_WORKSPACE}/shangyou/.github/workflows/Amlogic.yml ${X}
  yml_name2="$(grep 'name:' "${X}"  |grep -v '^#' |awk 'NR==1')"
  TARGE1="$(grep 'target: \[' "${X}" |sed 's/^[ ]*//g' |grep -v '^#' |sed 's/\[/\\&/' |sed 's/\]/\\&/')"
  sed -i "s?${yml_name2}?${yml_name1}?g" "${X}"
  sed -i "s?${TARGE1}?${TARGE2}?g" "${X}"
elif [[ "${SOURCE_CODE1}" == "IMMORTALWRT" ]]; then 
  cp -Rf ${GITHUB_WORKSPACE}/shangyou/.github/workflows/Immortalwrt.yml ${X}
  yml_name2="$(grep 'name:' "${X}"  |grep -v '^#' |awk 'NR==1')"
  TARGE1="$(grep 'target: \[' "${X}" |sed 's/^[ ]*//g' |grep -v '^#' |sed 's/\[/\\&/' |sed 's/\]/\\&/')"
  sed -i "s?${yml_name2}?${yml_name1}?g" "${X}"
  sed -i "s?${TARGE1}?${TARGE2}?g" "${X}"
elif [[ "${SOURCE_CODE1}" == "COOLSNOWWOLF" ]]; then
  cp -Rf ${GITHUB_WORKSPACE}/shangyou/.github/workflows/Lede.yml ${X}
  yml_name2="$(grep 'name:' "${cc}"  |grep -v '^#' |awk 'NR==1')"   
  TARGE1="$(grep 'target: \[' "${X}" |sed 's/^[ ]*//g' |grep -v '^#' |sed 's/\[/\\&/' |sed 's/\]/\\&/')"
  sed -i "s?${yml_name2}?${yml_name1}?g" "${X}"
  sed -i "s?${TARGE1}?${TARGE2}?g" "${X}"
elif [[ "${SOURCE_CODE1}" == "LIENOL" ]]; then 
  cp -Rf ${GITHUB_WORKSPACE}/shangyou/.github/workflows/Lienol.yml ${X}
  yml_name2="$(grep 'name:' "${X}"  |grep -v '^#' |awk 'NR==1')" 
  TARGE1="$(grep 'target: \[' "${X}" |sed 's/^[ ]*//g' |grep -v '^#' |sed 's/\[/\\&/' |sed 's/\]/\\&/')"
  sed -i "s?${yml_name2}?${yml_name1}?g" "${X}"
  sed -i "s?${TARGE1}?${TARGE2}?g" "${X}"
elif [[ "${SOURCE_CODE1}" == "OFFICIAL" ]]; then
  cp -Rf ${GITHUB_WORKSPACE}/shangyou/.github/workflows/Official.yml ${X}
  yml_name2="$(grep 'name:' "${X}"  |grep -v '^#' |awk 'NR==1')" 
  TARGE1="$(grep 'target: \[' "${X}" |sed 's/^[ ]*//g' |grep -v '^#' |sed 's/\[/\\&/' |sed 's/\]/\\&/')"
  sed -i "s?${yml_name2}?${yml_name1}?g" "${X}"
  sed -i "s?${TARGE1}?${TARGE2}?g" "${X}"
elif [[ "${SOURCE_CODE1}" == "XWRT" ]]; then 
  cp -Rf ${GITHUB_WORKSPACE}/shangyou/.github/workflows/Xwrt.yml ${X}
  yml_name2="$(grep 'name:' "${X}"  |grep -v '^#' |awk 'NR==1')" 
  TARGE1="$(grep 'target: \[' "${X}" |sed 's/^[ ]*//g' |grep -v '^#' |sed 's/\[/\\&/' |sed 's/\]/\\&/')"
  sed -i "s?${yml_name2}?${yml_name1}?g" "${X}"
  sed -i "s?${TARGE1}?${TARGE2}?g" "${X}"
else
   echo "无此文件"
fi
done
