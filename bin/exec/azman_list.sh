#!/usr/bin/env bash
#AZMAN_LIST V1P1
USESPLIT=false
fulln="${STDS[1]:-}"
fn="$(echo ${fulln%.*}|"${mysed}" "s;.part1;;"|"${mysed}" "s;.part01;;")"
ext="${fulln##*.}"
if [ "${fn##*.}" = "tar" ]; then
    ext="tar.${ext}"
    fn="${fn%.*}"
fi
if [ -z "${fulln}" ]; then
    echo -e "\e[31mERROR: Filename '' invalid.\e[0m"
    exit 1
elif ! [ -e "${fulln}" ]&&[ -e "${fulln}.001" ]; then
    USESPLIT=true
    mktmp
elif ! [ -e "${fulln}" ]&&[ -e "$(echo ${fulln}|"${mysed}" "s;.rar;.part01.rar;")" ]&&[ ${ext} = "rar" ];then
    fulln="$(echo ${fulln}|"${mysed}" "s;.rar;.part01.rar;")"
    USESPLIT=true
    mktmp
elif ! [ -e "${fulln}" ]&&[ -e "$(echo ${fulln}|"${mysed}" "s;.rar;.part1.rar;")" ]&&[ ${ext} = "rar" ];then
    fulln="$(echo ${fulln}|"${mysed}" "s;.rar;.part1.rar;")"
    USESPLIT=true
    mktmp
elif ! [ -e "${fulln}" ]; then
    echo -e "\e[31mERROR: Filename '"${fulln}"' invalid.\e[0m"
    exit 1
fi
ckext
echo -e "\e[33mReceived: ${0} ${STDS[0]} "${fulln}" ${OPT:-} ==>Extension=${ext}\e[0m"
# ============ Start ============
case ${ext} in
"tar") # ============ tar ============
    if [ "${mytar}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: Tar NO exist!\e[0m"
        exit 1
    fi
    if ${USESPLIT}; then
        file_i=1
        in_i=001
        while [ -f "${fulln}".${in_i} ]; do
            "${mycat}" "${fulln}".${in_i} >>"${tempf}"
            file_i=$((${file_i} + 1))
            in_i=$(fixthree ${file_i})
        done
        unset file_i in_1
        "${mytar}" -tvf "${tempf}"
    else
        "${mytar}" -tvf "${fulln}"
    fi
    ;;
"tar.gz" | "tgz" | "tar.GZ") # ============ tgz ============
    if [ "${mygzip}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: GZip NO exist!\e[0m"
        exit 1
    fi
    if [ "${mytar}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: Tar NO exist!\e[0m"
        exit 1
    fi
    if ${USESPLIT}; then
        stdtl "${mygzip} -dk"
    else
        "${mytar}" -tzvf "${fulln}"
    fi
    ;;
"tar.xz" | "txz") # ============ txz ============
    if [ "${myxzip}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: XZ NO exist!\e[0m"
        exit 1
    fi
    if [ "${mytar}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: Tar NO exist!\e[0m"
        exit 1
    fi
    if ${USESPLIT}; then
        stdtl "${myxzip} -dk"
    else
        "${mytar}" -tJvf "${fulln}"
    fi
    ;;
"tar.bz2" | "tbz") # ============ tbz ============
    if [ "${mybzip2}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: BZip2 NO exist!\e[0m"
        exit 1
    fi
    if [ "${mytar}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: Tar NO exist!\e[0m"
        exit 1
    fi
    if ${USESPLIT}; then
        stdtl "${mybzip2} -dk"
    else
        "${mytar}" -tjvf "${fulln}"
    fi
    ;;
"tar.lzma" | "tar.lz" | "tlz") # ============ tlz ============
    if [ "${myxzip}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: LZMA SDK NO exist!\e[0m"
        exit 1
    fi
    if [ "${mytar}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: Tar NO exist!\e[0m"
        exit 1
    fi
    if ${USESPLIT}; then
        stdtl "${myxzip} -dk --format=lzma"
    else
        "${myxzip}" -dc "${fulln}" | "${mytar}" -tv -f -
    fi
    ;;
"gz" | "GZ") # ============ gz ============
    if [ "${myzgip}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: GZip NO exist!\e[0m"
        exit 1
    fi
    if ${USESPLIT};then echo -e "\e[31mERROR: Splitted archive not supported!\e[0m";exit 1;fi
    "${mygzip}" -l "${fulln}"
    ;;
"xz") # ============ xz ============
    if [ "${myxzip}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: XZ NO exist!\e[0m"
        exit 1
    fi
    if ${USESPLIT};then echo -e "\e[31mERROR: Splitted archive not supported!\e[0m";exit 1;fi
    "${myxzip}" -l "${fulln}"
    ;;
"bz2") # ============ bz2 ============
    echo -e "\e[31mERROR: BZip2 do not support this function!\e[0m"
    ;;
"lz" | "lzma") # ============ lz ============
    echo -e "\e[31mERROR: XZ Utils do not support this function!\e[0m"
    ;;
"7z") # ============ 7z ============
    if [ "${my7z}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: p7zip NO exist!\e[0m"
        exit 1
    fi
    if [ ! -f "${fulln}" ] && [ -f "${fulln}.001" ];then
        fulln="${fulln}.001"
    fi
    "${my7z}" l "${fulln}"
    ;;
"zip") # ============ zip ============
    if [ "${myunzip}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: unzip NO exist!\e[0m"
        exit 1
    fi
    if [ -f "${fn}".z01 ]; then
        if [ "${myzip}" = 'ylukh' ]; then
            echo -e "\e[31mERROR: zip NO exist!\e[0m"
            exit 1
        fi
        mktmp
        "${mycp}" "${fn}".z* "${tempdir}"/
        "${myzip}" -FF "${tempdir}"/"${fn}".zip --out "${tempdir}"/"${fn}".fzip
        "${myunzip}" -v "${tempdir}"/"${fn}".fzip
    else
        "${myunzip}" -v "${fulln}"
    fi
    ;;
"rar")
    if [ "${myunrar}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: rar NO exist!\e[0m"
        exit 1
    fi
    "${myunrar}" v "${fulln}"
    ;;
esac
# ============ Finished ============
echo -e "\e[33mFinished.\e[0m"
exit 0
