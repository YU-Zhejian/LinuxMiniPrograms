#!/usr/bin/env bash
#AZMAN_LIST V1
USESPLIT=false
fulln="${STDI[1]:-}"
fn="${fulln%.*}"
ext="${fulln##*.}"
if [ "${fn##*.}" = "tar" ]; then
    ext="tar.${ext}"
    fn="${fn%.*}"
fi
if [ -z "${fulln}" ]; then
    echo -e "\e[31mERROR: Filename '' invalid.\e[0m"
    exit 1
elif [ -e "${fulln}".part1.rar ] && [ ${ext} = 'rar' ]; then
    fn=$(echo ${fulln} | ${mysed} "s/.part1.rar//")
elif [ -e "${fulln}".001 ]; then
    USESPLIT=true
    mktmp
elif ! [ -e "${fulln}" ]; then
    echo -e "\e[31mERROR: Filename '"${fulln}"' invalid.\e[0m"
    exit 1
fi
if [[ "tar,tar.gz,tgz,tar.GZ,tar.xz,txz,tar.bz2,bz,tar.lzma,tar.lz,tlz,gz,bgz,GZ,xz,bz2,lzma,lz" =~ .*"ext".* ]]; then
    echo -e "\e[31mERROR: Extension name '${ext}' invalid.\nYou can execute 'autozip' without any argument or option to check available method and extension.\e[0m"
    exit 1
else
    echo -e "\e[33mReceived: ${0} ${STDS[0]} "${fulln}" ${OPT:-} ==>Extension=${ext}\e[0m"
fi

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
        stdtl "\"${mygzip}\" -dk"
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
        stdtl "\"${myxz}\" -dk"
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
        stdtl "\"${mybzip2}\" -dk"
    else
        "${mytar}" -xjvf "${fulln}"
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
        stdtl "\"${myxz}\" -dk --format=lzma"
    else
        "${myxz}" -dc "${fulln}" | "${mytar}" -tv -f -
    fi
    ;;
"gz" | "GZ") # ============ gz ============
    if [ "${myzgip}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: GZip NO exist!\e[0m"
        exit 1
    fi
    if ${USESPLIT};then echo -e "\e[31mERROR: Splitted archive not supported!\e[0m";fi
    "${myzgip}" -l "${fulln}"
    ;;
"xz") # ============ xz ============
    if [ "${myxzip}" = 'ylukh' ]; then
        echo -e "\e[31mERROR: XZ NO exist!\e[0m"
        exit 1
    fi
    if ${USESPLIT};then echo -e "\e[31mERROR: Splitted archive not supported!\e[0m";fi
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
        ${mycp} "${fn}".z* "${tempdir}"/
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
