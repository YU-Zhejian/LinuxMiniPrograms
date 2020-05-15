#!/usr/bin/env bash
# LIBAUTOZIP V2P10
USESPLIT=false
REMOVE=false
#Load libopt
{ . "${DN}"/../lib/libisopt && . "${DN}"/../lib/libdo; } && { echo -e "\e[33mlibisopt, libdo loaded.\e[0m"; } || {
    echo -e "\e[31mFail to load libisopt, libdo.\e[0m"
    exit 1
}
# Check for all compoments: backend.
function TAR() {
    tar --help &>>/dev/null
    echo ${?}
}
function GZIP() {
    gzip -h &>>/dev/null
    echo ${?}
}
function BGZIP() {
    bgzip -h &>>/dev/null
    echo ${?}
}
function PIGZ() {
    pigz -h &>>/dev/null
    echo ${?}
}
function XZIP() {
    xz -h &>>/dev/null
    echo ${?}
}
function BZIP2() {
    bzip2 -h &>>/dev/null
    echo ${?}
}
function Z7() {
    7za -h &>>/dev/null
    echo ${?}
}
function ZIP() {
    zip -h &>>/dev/null
    echo ${?}
}
function RAR() {
    rar -\? &>>/dev/null
    echo ${?}
}
function UNZIP() {
    unzip -h &>>/dev/null
    echo ${?}
}
function UNRAR() {
    unrar -\? &>>/dev/null
    echo ${?}
}
function PARALLEL() {
    /usr/bin/parallel -h &>>/dev/null
    echo ${?}
}
function preck() {
    LVL=""
    CONFN="${DN}"/../etc/autozip.conf
    USEPARALLEL=false
    if ! [ -f "${CONFN}" ]; then
        echo -e "\e[31mWARNING: Configure file NOT exist. Will generate one by default value.\e[0m"
        echo "NOPARALLEL" >${CONFN}
    elif [ -d "${CONFN}" ]; then
        echo -e "\e[31mERROR: Configure file is a directory.\e[0m"
        exit 1
    else
        i=0
        local conf[0]
        while read line; do
            conf[${i}]=${line}
            i=$((${i} + 1))
        done <"${CONFN}"
        unset line
        if [ "${conf[0]}" = "PARALLEL" ] && [ $(PARALLEL) -eq 0 ]; then
            USEPARALLEL=true
            PP="/usr/bin/parallel"
            echo -e "\e[33mWill use GNU Parallel if possible.\e[0m"
        fi
        unset conf
    fi
}
# Check for all compoments: frontend.
function autozipck() {
    TAR=$(TAR)
    echo -e "\e[33mStart checking all compoments..."
    if [ ${TAR} -eq 0 ]; then
        echo -e "Checking for 'tar'...\e[32mOK\e[33m"
        availext="tar"
    else
        echo -e "Checking for 'tar'...\e[31mNO\e[33m"
    fi
    if [ $(GZIP) -eq 0 ]; then
        echo -e "Checking for 'gzip'...\e[32mOK\e[33m"
        availext="${availext}, gz, GZ"
        if [ ${TAR} -eq 0 ]; then availext="${availext}, tar.gz, tar.GZ, tgz"; fi
    else
        echo -e "Checking for 'gzip'...\e[31mNO\e[33m"
    fi
    if [ $(PIGZ) -eq 0 ]; then
        echo -e "Checking for 'pigz'...\e[32mOK\e[33m"
    else
        echo -e "Checking for 'pigz'...\e[31mNO\e[33m"
    fi
    if [ $(BGZIP) -eq 0 ]; then
        echo -e "Checking for 'bgzip'...\e[32mOK\e[33m"
        availext="${availext}, bgz"
    else
        echo -e "Checking for 'bgzip'...\e[31mNO\e[33m"
    fi
    if [ $(XZIP) -eq 0 ]; then
        echo -e "Checking for 'xz'...\e[32mOK\e[33m"
        availext="${availext}, xz, lzma, lz"
        if [ ${TAR} -eq 0 ]; then availext="${availext}, tar.xz, txz, tar.lzma, tlz"; fi
    else
        echo -e "Checking for 'xz'...\e[31mNO\e[33m"
    fi
    if [ $(BZIP2) -eq 0 ]; then
        echo -e "Checking for 'bzip2'...\e[32mOK\e[33m"
        availext="${availext}, bz2"
        if [ ${TAR} -eq 0 ]; then availext="${availext}, tar.bz2, tbz"; fi
    else
        echo -e "Checking for 'bzip2'...\e[31mNO\e[33m"
    fi
    if [ $(Z7) -eq 0 ]; then
        echo -e "Checking for '7z'...\e[32mOK\e[33m"
        availext="${availext}, 7z"
    else
        echo -e "Checking for '7z'...\e[31mNO\e[33m"
    fi
    if [ $(ZIP) -eq 0 ]; then
        echo -e "Checking for 'zip'...\e[32mOK\e[33m"
        availext="${availext}, zip"
    else
        echo -e "Checking for 'zip'...\e[31mNO\e[33m"
    fi
    if [ $(RAR) -eq 0 ]; then
        echo -e "Checking for 'rar'...\e[32mOK\e[33m"
        availext="${availext}, rar"
    else
        echo -e "Checking for 'rar'...\e[31mNO\e[33m"
    fi
    if [ $(UNZIP) -eq 0 ]; then
        echo -e "Checking for 'unzip'...\e[32mOK\e[33m"
    else
        echo -e "Checking for 'unzip'...\e[31mNO\e[33m"
    fi
    if [ $(UNRAR) -eq 0 ]; then
        echo -e "Checking for 'unrar'...\e[32mOK\e[33m"
    else
        echo -e "Checking for 'unrar'...\e[31mNO\e[33m"
    fi
    if [ $(PARALLEL) -eq 0 ]; then
        echo -e "Checking for 'parallel' in /usr/bin...\e[32mOK\e[33m"
    else
        echo -e "Checking for 'parallel' in /usr/bin...\e[31mNO\e[33m"
    fi
    echo -e "Available extension name on your computer:\n${availext}"
    echo "Configure file ${CONFN} are as follows:"
    echo -e "=====Begin ${CONFN}=====\e[0m"
    cat "${CONFN}"
    echo -e "\e[33m=====End   ${CONFN}=====\e[0m"
}
#Modify Filenames
function mfn() {
    echo ${*} | sed -e "s,(,\\\\\(,g" | sed -e "s,),\\\\\),g" | sed -e "s,\[,\\\\\[,g" | sed -e "s,\],\\\\\],g" | sed -e "s,<,\\\\\<,g" | sed -e "s,>,\\\\\>,g" | sed -e "s,{,\\\\\{,g" | sed -e "s,},\\\\\},g"
}
#Makt temporaty resources
function mktmp() {
    tempdir=$(mktemp -dt autozip.XXXXXX)
    tempf=$(mktemp -t autozip.XXXXXX)
    echo -e "\e[33mTEMP file '$tempf' and directory '$tempdir' made.\e[0m"
}
# Check opt
function ppopt() {
    for opt in "${@}"; do
        if isopt ${opt}; then
            case ${opt} in
            "-h" | "--help")
                yldoc autozip
                exit 0
                ;;
            "-v" | "--version")
                echo "Version 2 patch 10"
                exit 0
                ;;
            "--force")
                ISFORCE=true
                ;;
            --force-parallel\:*)
                PP=${opt:17}
                if [ $(
                    $PP -h &>>/dev/null
                    echo ${?}
                ) -eq 0 ]; then
                    USEPARALLEL=true
                    echo -e "\e[33mWill use GNU Parallel in '$PP'.\e[0m"
                else
                    echo -e "\e[31mERROR: GNU Parallel path '$PP' invalid.\e[0m"
                    if [ $(PARALLEL) -eq 0 ]; then
                        PP="/usr/bin/parallel"
                        echo -e "\e[31mERROR: Will use GNU Parallel in /usr/bin/parallel\e[0m"
                    fi
                fi
                ;;
            "--remove")
                echo -e "\e[33mWARNING: Will remove $fn if success.\e[0m"
                REMOVE=true
                ;;

            "-s" | "--split")
                if ! ${ISAOTOZIP}; then
                    echo -e "\e[31mERROR: Option '${opt}' invalid.\e[0m"
                    exit 1
                fi
                USESPLIT=true
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
                if ! ${ISAOTOZIP}; then
                    echo -e "\e[31mERROR: Option '${opt}' invalid.\e[0m"
                    exit 1
                fi
                USESPLIT=true
                SPLIT=${opt:3}
                ;;
            --split\:*)
                if ! ${ISAOTOZIP}; then
                    echo -e "\e[31mERROR: Option '${opt}' invalid.\e[0m"
                    exit 1
                fi
                USESPLIT=true
                SPLIT=${opt:8}
                ;;
            *)
                echo -e "\e[31mERROR: Option '${opt}' invalid.\e[0m"
                exit 1
                ;;
            esac
            OPT="${OPT} ${opt}"
        else
            STDS="${STDS} ${opt}"
        fi
    done
}
