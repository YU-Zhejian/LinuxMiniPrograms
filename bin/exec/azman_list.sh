#!/usr/bin/env bash
#AZMAN_LIST V1
fulln="${STDI[1]:-}"
if ! [ -n "${fulln}" ]; then
    echo -e "\e[31mERROR: Filename '"${fulln}"' invalid.\e[0m"
    exit 1
fi
fn="${fulln%.*}"
ext="${fulln##*.}"
if [ "${fn##*.}" = "tar" ]; then
    ext="tar.${ext}"
    fn="${fn%.*}"
fi
if [ -e "${fulln}".part1.rar ] && [ ${ext} = 'rar' ]; then
    echo -e "\e[31mERROR: Splitted file '"${fulln}"' not supported.\e[0m"
    exit 1
elif [ -e "${fulln}".z01 ] && [ ${ext} = 'zip' ]; then
    echo -e "\e[31mERROR: Splitted file '"${fulln}"' not supported.\e[0m"
    exit 1
elif [ -e "${fulln}".001 ]; then
    echo -e "\e[31mERROR: Splitted file '"${fulln}"' not supported.\e[0m"
    exit 1
elif ! [ -e "${fulln}" ]; then
    echo -e "\e[31mERROR: Filename '"${fulln}"' invalid.\e[0m"
    exit 1
fi
echo -e "\e[33mReceived: ${0} ${STDS[0]} "${fulln}" ${OPT:-} ==>Extension=${ext}\e[0m"
# ============ Start ============
case ${ext} in
"tar") # ============ tar ============
    if [ "${mytar}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: Tar NO exist!\e[0m"
        exit 1
    fi
    "${mytar}" -tvf "${fulln}"
    ;;
"tar.gz" | "tgz" | "tar.GZ") # ============ tgz ============
    if [ "${mygzip}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: GZip NO exist!\e[0m"
        exit 1
    fi
    if [ "${mytar}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: GNU Tar NO exist!\e[0m"
        exit 1
    fi
    "${mytar}" -tzvf "${fulln}"
    ;;
"tar.xz" | "txz") # ============ txz ============
    if [ "${myxzip}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: XZ NO exist!\e[0m"
        exit 1
    fi
    if [ "${mytar}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: GNU Tar NO exist!\e[0m"
        exit 1
    fi
    "${mytar}" -tJvf "${fulln}"
    ;;
"tar.bz2" | "tbz") # ============ tbz ============
    if [ "${mybzip2}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: BZip2 NO exist!\e[0m"
        exit 1
    fi
    if [ "${mytar}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: GNU Tar NO exist!\e[0m"
        exit 1
    fi
    "${mytar}" -tjvf "${fulln}"
    ;;
"tar.lzma" | "tar.lz" | "tlz") # ============ tlz ============
    if [ "${myxzip}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: LZMA SDK NO exist!\e[0m"
        exit 1
    fi
    if [ "${mytar}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: GNU Tar NO exist!\e[0m"
        exit 1
    fi
    echo -e "\e[31mWARNING: Unsupported under BSD!\e[0m"
    "${mytar}" -tvf "${fulln}" --lzma
    ;;
"gz" | "GZ") # ============ gz ============
    if [ "${myzgip}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: GZip NO exist!\e[0m"
        exit 1
    fi
    "${myzgip}" -l "${fulln}"
    ;;
"xz") # ============ xz ============
    if [ "${myxzip}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: XZ NO exist!\e[0m"
        exit 1
    fi
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
    "${my7z}" l "${fulln}"
    ;;
"zip") # ============ zip ============
    if [ "${myunzip}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: unzip NO exist!\e[0m"
        exit 1
    fi
    "${myunzip}" -v "${fulln}"
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
