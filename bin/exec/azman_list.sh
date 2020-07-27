#!/usr/bin/env bash
#AZMAN_LIST V1P2
USESPLIT=false
unset STDS[0]
ISBLANK=true
for fulln in "${STDS[@]}"; do
    ISBLANK=false
    fn="$(echo ${fulln%.*} | "${mysed}" "s;.part1;;" | "${mysed}" "s;.part01;;")"
    ext="${fulln##*.}"
    if [ "${fn##*.}" = "tar" ]; then
        ext="tar.${ext}"
        fn="${fn%.*}"
    fi
    if ! [ -f "${fulln}" ] && [ -f "${fulln}.001" ]; then
        USESPLIT=true
        mktmp
    elif ! [ -f "${fulln}" ] && [ -f "$(echo ${fulln} | "${mysed}" "s;.rar;.part01.rar;")" ] && [ ${ext} = "rar" ]; then
        fulln="$(echo ${fulln} | "${mysed}" "s;.rar;.part01.rar;")"
        USESPLIT=true
        mktmp
    elif ! [ -f "${fulln}" ] && [ -f "$(echo ${fulln} | "${mysed}" "s;.rar;.part1.rar;")" ] && [ ${ext} = "rar" ]; then
        fulln="$(echo ${fulln} | "${mysed}" "s;.rar;.part1.rar;")"
        USESPLIT=true
        mktmp
    elif ! [ -f "${fulln}" ]; then
        echo -e "\033[31mERROR: Filename '"${fulln}"' invalid.\033[0m"
        exit 1
    fi
    ckext
    echo -e "\033[33mReceived: ${0} ${STDS[0]} "${fulln}" ${OPT:-} ==>Extension=${ext}\033[0m"
    # ============ Start ============
    case ${ext} in
    "tar") # ============ tar ============
        if [ "${mytar}" = 'ylukh' ]; then
            echo -e "\033[31mERROR: Tar NO exist! \033[0m"
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
            echo -e "\033[31mERROR: GZip NO exist! \033[0m"
            exit 1
        fi
        if [ "${mytar}" = 'ylukh' ]; then
            echo -e "\033[31mERROR: Tar NO exist! \033[0m"
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
            echo -e "\033[31mERROR: XZ NO exist! \033[0m"
            exit 1
        fi
        if [ "${mytar}" = 'ylukh' ]; then
            echo -e "\033[31mERROR: Tar NO exist! \033[0m"
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
            echo -e "\033[31mERROR: BZip2 NO exist! \033[0m"
            exit 1
        fi
        if [ "${mytar}" = 'ylukh' ]; then
            echo -e "\033[31mERROR: Tar NO exist! \033[0m"
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
            echo -e "\033[31mERROR: LZMA SDK NO exist! \033[0m"
            exit 1
        fi
        if [ "${mytar}" = 'ylukh' ]; then
            echo -e "\033[31mERROR: Tar NO exist! \033[0m"
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
            echo -e "\033[31mERROR: GZip NO exist! \033[0m"
            exit 1
        fi
        if ${USESPLIT}; then
            echo -e "\033[31mERROR: Splitted archive not supported! \033[0m"
            exit 1
        fi
        "${mygzip}" -l "${fulln}"
        ;;
    "xz") # ============ xz ============
        if [ "${myxzip}" = 'ylukh' ]; then
            echo -e "\033[31mERROR: XZ NO exist! \033[0m"
            exit 1
        fi
        if ${USESPLIT}; then
            echo -e "\033[31mERROR: Splitted archive not supported! \033[0m"
            exit 1
        fi
        "${myxzip}" -l "${fulln}"
        ;;
    "bz2") # ============ bz2 ============
        echo -e "\033[31mERROR: BZip2 do not support this function! \033[0m"
        ;;
    "lz" | "lzma") # ============ lz ============
        echo -e "\033[31mERROR: XZ Utils do not support this function! \033[0m"
        ;;
    "7z") # ============ 7z ============
        if [ "${my7z}" = 'ylukh' ]; then
            echo -e "\033[31mERROR: p7zip NO exist! \033[0m"
            exit 1
        fi
        if [ ! -f "${fulln}" ] && [ -f "${fulln}.001" ]; then
            fulln="${fulln}.001"
        fi
        "${my7z}" l "${fulln}"
        ;;
    "zip") # ============ zip ============
        if [ "${myunzip}" = 'ylukh' ]; then
            echo -e "\033[31mERROR: unzip NO exist! \033[0m"
            exit 1
        fi
        if [ -f "${fn}".z01 ]; then
            if [ "${myzip}" = 'ylukh' ]; then
                echo -e "\033[31mERROR: zip NO exist! \033[0m"
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
            echo -e "\033[31mERROR: rar NO exist! \033[0m"
            exit 1
        fi
        "${myunrar}" v "${fulln}"
        ;;
    esac
done
# ============ Finished ============
if ${ISBLANK};then
    echo -e "\033[31mERROR: NO FILENAME.\033[0m"
    exit 1
fi
echo -e "\033[33mFinished.\033[0m"
exit 0
