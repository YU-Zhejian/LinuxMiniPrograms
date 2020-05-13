#!/bin/bash
# PLS V2
echo -e "\e[33mYuZJLab PATH ls"
echo -e "Copyright (C) 2019-2020 YU Zhejian\e[0m"
wd=${PWD}
oldifs="${IFS}"
DN=$(dirname ${0})
function gepath() {
    local mypath="$(echo ${PATH}):${wd}"
    IFS=":"
    eachpath=(${mypath})
    IFS=''
}
function my_grep(){
	regstr=${1}
	local tmpffff=$(mktemp -t pls.XXXXXX)
    cat ${tmpff} | grep -v "${regstr}" >${tmpffff}
    mv ${tmpffff} ${tmpff}
}

function do_search() {
    if ! [ -d ${dir} ]; then return; fi
    echo -e "\e[33mSearching ${dir}...\e[0m" >&2
    local item
    local tmpff
    tmpff=$(mktemp -t pls.XXXXXX)
    ls -1 -F ${dir}| sed "s;^;$(echo ${dir})/;" >${tmpff}
    if ! ${allow_d}; then
		my_grep '/$'
    fi
    if ! ${allow_x}; then
        my_grep '\*$'
    fi
    if ! ${allow_o}; then
        my_grep '[^\*/]$'
    fi
    cat ${tmpff} >>${tmpf}
    rm ${tmpff}
}
more="more"
{
    . ${DN}/../lib/libisopt
} && { echo -e "\e[33mlibisopt loaded\e[0m"; } || {
    echo -e "\e[31mFail to load libisopt.\e[0m"
    exit 1
}
allow_x=true
allow_d=false
allow_o=true
for opt in "${@}"; do
    if isopt ${opt}; then
        case ${opt} in
        "-h" | "--help")
            yldoc pls
            exit 0
            ;;
        "-v" | "--version")
            echo "Version 2"
            exit 0
            ;;
        "--no-x")
            allow_x=false
            ;;
        "--allow-d")
            allow_d=true
            ;;
        "--no-o")
            allow_o=false
            ;;
        "-l" | "--list")
            gepath
            for dir in "${eachpath[@]}"; do
                if [ -d ${dir} ]; then echo "${dir}/"; fi
            done
            exit 0
            ;;
        "-i" | "--invalid")
            gepath
            for dir in "${eachpath[@]}"; do
                if ! [ -d ${dir} ]; then echo "${dir}/"; fi
            done
            exit 0
            ;;
        --more\:*)
            more=${opt:7}
            ;;
        *)
            echo -e "\e[31mERROR: Option '${opt}' invalid.\e[0m"
            exit 1
            ;;
        esac
    else
        STDS="${STDS} ${opt}"
    fi
done
gepath
tmpf=$(mktemp -t pls.XXXXXX)
echo -e "\e[33mReading database...\e[0m"
for dir in "${eachpath[@]}"; do
    do_search
done
if [ -z "${STDS}" ]; then
    cat ${tmpf} | ${more}
else
    IFS=" "
    STDI=(${STDS})
    IFS=''
    grepstr=''
    for fn in "${STDI[@]}"; do
		grepstr=${grepstr}" -e "${fn}
    done
    eval cat ${tmpf}\|grep ${grepstr}\|${more}
fi
rm ${tmpf}
IFS="${oldifs}"
