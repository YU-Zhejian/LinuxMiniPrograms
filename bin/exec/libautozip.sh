#!/usr/bin/env bash
# LIBAUTOZIP V3P2
REMOVE=false
USEPARALLEL=false
ISFORCE=false
OPT=()
STDS=()
CONFN="${DN}"/../etc/autozip.conf
. "${DN}"/../lib/libisopt
. "${DN}"/../etc/path.sh
function preck() {
    if ! [ -f "${CONFN}" ]; then
        echo -e "\033[31mWARNING: Configure file NOT exist. Will generate one by default value.\033[0m"
        echo "NOPARALLEL" >"${CONFN}"
    elif [ -d "${CONFN}" ]; then
        echo -e "\033[31mERROR: Configure file is a directory.\033[0m"
        exit 1
    else
        local conf[0]
        while read line; do
            conf=("${conf[@]}" "${line}")
            unset line
        done <"${CONFN}"
        if [ "${conf[0]}" = "PARALLEL" ] && [ ${myparallel} != 'ylukh' ]; then
            USEPARALLEL=true
            echo -e "\033[33mWill use GNU Parallel if possible.\033[0m"
        fi
        unset conf
    fi
}
# Check for all compoments: frontend.
function autozipck() {
    echo -e "\033[33mStart checking all compoments..."
    if [ ${mytar} != 'ylukh' ]; then
        echo -e "Checking for 'tar'...\033[32mOK\033[33m"
        availext="tar"
    else
        echo -e "Checking for 'tar'...\033[31mNO\033[33m"
    fi
    if [ ${mygzip} != 'ylukh' ]; then
        echo -e "Checking for 'gzip'...\033[32mOK\033[33m"
        availext="${availext}, gz, GZ"
        if [ ${mytar} != 'ylukh' ]; then availext="${availext}, tar.gz, tar.GZ, tgz"; fi
    else
        echo -e "Checking for 'gzip'...\033[31mNO\033[33m"
    fi
    if [ ${mypigz} != 'ylukh' ]; then
        echo -e "Checking for 'pigz'...\033[32mOK\033[33m"
    else
        echo -e "Checking for 'pigz'...\033[31mNO\033[33m"
    fi
    if [ ${mybgzip} != 'ylukh' ]; then
        echo -e "Checking for 'bgzip'...\033[32mOK\033[33m"
        availext="${availext}, bgz"
    else
        echo -e "Checking for 'bgzip'...\033[31mNO\033[33m"
    fi
    if [ ${myxzip} != 'ylukh' ]; then
        echo -e "Checking for 'xz'...\033[32mOK\033[33m"
        availext="${availext}, xz, lzma, lz"
        if [ ${mytar} != 'ylukh' ]; then availext="${availext}, tar.xz, txz, tar.lzma, tlz"; fi
    else
        echo -e "Checking for 'xz'...\033[31mNO\033[33m"
    fi
    if [ ${mybzip2} != 'ylukh' ]; then
        echo -e "Checking for 'bzip2'...\033[32mOK\033[33m"
        availext="${availext}, bz2"
        if [ ${mytar} != 'ylukh' ]; then availext="${availext}, tar.bz2, tbz"; fi
    else
        echo -e "Checking for 'bzip2'...\033[31mNO\033[33m"
    fi
    if [ ${my7z} != 'ylukh' ]; then
        echo -e "Checking for '7z'...\033[32mOK\033[33m"
        availext="${availext}, 7z"
    else
        echo -e "Checking for '7z'...\033[31mNO\033[33m"
    fi
    if [ ${myzip} != 'ylukh' ]; then
        echo -e "Checking for 'zip'...\033[32mOK\033[33m"
        availext="${availext}, zip(Add)"
    else
        echo -e "Checking for 'zip'...\033[31mNO\033[33m"
    fi
    if [ ${myrar} != 'ylukh' ]; then
        echo -e "Checking for 'rar'...\033[32mOK\033[33m"
        availext="${availext}, rar(Add)"
    else
        echo -e "Checking for 'rar'...\033[31mNO\033[33m"
    fi
    if [ ${myunzip} != 'ylukh' ]; then
        echo -e "Checking for 'unzip'...\033[32mOK\033[33m"
        availext="${availext}, zip(Extract)"
    else
        echo -e "Checking for 'unzip'...\033[31mNO\033[33m"
    fi
    if [ ${myunrar} != 'ylukh' ]; then
        echo -e "Checking for 'unrar'...\033[32mOK\033[33m"
        availext="${availext}, rar(Extract)"
    else
        echo -e "Checking for 'unrar'...\033[31mNO\033[33m"
    fi
    if [ ${myparallel} != 'ylukh' ]; then
        echo -e "Checking for 'parallel' in ${myparallel}...\033[32mOK\033[33m"
    else
        echo -e "Checking for 'parallel' ...\033[31mNO\033[33m"
    fi
    echo -e "Available extension name on your computer:\n${availext}"
    echo "Configure file ${CONFN} are as follows:"
    echo -e "=====Begin ${CONFN}=====\033[0m"
    "${mycat}" "${CONFN}"
    echo -e "\033[33m=====End   ${CONFN}=====\033[0m"
}
#Makt temporaty resources
function mktmp() {
    tempdir="$(mktemp -dt autozip.XXXXXX)"
    tempf="$(mktemp -t autozip.XXXXXX)"
    echo -e "\033[33mTEMP file '${tempf}' and directory '${tempdir}' made.\033[0m"
}
# Check opt
function ppopt() {
    for opt in "${@}"; do
        if isopt "${opt}"; then
            case "${opt}" in
            "-h" | "--help")
                yldoc autozip
                exit 0
                ;;
            "-v" | "--version")
                echo "Version 3 Patch 2"
                exit 0
                ;;
            "--force")
                echo -e "\033[31mWARNING: Will remove the archive if exists.\033[0m"
                ISFORCE=true
                ;;
            "--remove")
                echo -e "\033[31mWARNING: Will remove the original file if success.\033[0m"
                REMOVE=true
                ;;
            "-s" | "--split")
                if ! ${ISAUTOZIP}; then
                    echo -e "\033[31mERROR: Option '${opt}' invalid.\033[0m"
                    exit 1
                fi
                case ${ext} in
                "rar" | "zip" | "7z")
                    SPLIT=1024m
                    ;;
                *)
                    SPLIT=1G
                    ;;
                esac
                ;;
            -s\:*)
                if ! ${ISAUTOZIP}; then
                    echo -e "\033[31mERROR: Option '${opt}' invalid.\033[0m"
                    exit 1
                fi
                SPLIT=${opt:3}
                ;;
            --split\:*)
                if ! ${ISAUTOZIP}; then
                    echo -e "\033[31mERROR: Option '${opt}' invalid.\033[0m"
                    exit 1
                fi
                SPLIT=${opt:8}
                ;;
            *)
                echo -e "\033[31mERROR: Option '${opt}' invalid.\033[0m"
                exit 1
                ;;
            esac
            OPT=("${OPT[@]}" "${opt}")
        else
            STDS=("${STDS[@]}" "${opt}")
        fi
    done
    if ! ${ISFORCE};then
        echo -e "\033[31mWARNING: Will rename the archive if exists.\033[0m"
    fi
}
# Make a number 3 digit
function fixthree() {
    local fout="${1}"
    while [ ${#fout} -lt 3 ]; do
        fout="0${fout}"
    done
    echo ${fout}
}
# Standard_C heads
function stdc_h() {
    local file_i=1
    local in_i=001
    if ${USEPARALLEL}; then
        while [ -f "${fulln}".${in_i} ]; do
            echo "\"${mycat}\" \"${PWD}/${fulln}\".${in_i} | ${*}>>\"${tempdir}\"/${in_i}" >>"${tempdir}"/"${in_i}".sh
            file_i=$((${file_i} + 1))
            in_i=$(fixthree ${file_i})
        done
        "${myfind}" "${tempdir}"/*.sh|"${myparallel}" bash
    else
        while [ -f "${fulln}".${in_i} ]; do
            "${mycat}" "${fulln}".${in_i} | ${*} >>"${tempdir}"/${in_i}
            file_i=$((${file_i} + 1))
            in_i=$(fixthree ${file_i})
        done
    fi
}
# standard TAR creator
function stdtc() {
    stdc_h "${@}"
    local file_i=1
    local in_i=001
    while [ -f "${fulln}".${in_i} ]; do
        "${mycat}" "${tempdir}"/${in_i} >>"${tempf}"
        file_i=$((${file_i} + 1))
        in_i=$(fixthree ${file_i})
    done
    unset file_i in_1
    "${mytar}" -xvf "${tempf}"
}
# standard TAR lister
function stdtl() {
    stdc_h "${@}"
    local file_i=1
    local in_i=001
    while [ -f "${fulln}".${in_i} ]; do
        "${mycat}" "${tempdir}"/${in_i} >>"${tempf}"
        file_i=$((${file_i} + 1))
        in_i=$(fixthree ${file_i})
    done
    unset file_i in_1
    "${mytar}" -tvf "${tempf}"
}
# standard FILE creator
function stdfc() {
    stdc_h "${@}"
    local file_i=1
    local in_i=001
    while [ -f "${fulln}".${in_i} ]; do
        "${mycat}" "${tempdir}"/${in_i} >>"${fn}"
        file_i=$((${file_i} + 1))
        in_i=$(fixthree ${file_i})
    done
    unset file_i in_1
}
# Check extension name
function ckext() {
case "${ext}" in
    "tar" | "tar.gz" | "tgz" | "tar.GZ" | "tar.xz" | "txz" | "tar.bz2" | "tbz" | "tar.lzma" | "tar.lz" | "tlz" | "gz" | "bgz" | "GZ" | "xz" | "bz2" | "lzma" | "lz"|"rar"|"zip"|"7z") ;;

    *)
        echo -e "\033[31mERROR: Extension name '${ext}' invalid.\nYou can execute 'autozip' without any argument or option to check available method and extension.\033[0m"
        exit 1
        ;;
    esac
}