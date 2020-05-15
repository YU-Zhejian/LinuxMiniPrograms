#!/usr/bin/env bash
# PLS V2P2
wd="${PWD}"
oldifs="${IFS}"
DN=$(dirname ${0})
function my_grep() {
    regstr="${1}"
    local tmpffff=$(mktemp -t pls.XXXXXX)
    cat "${tmpf}" | grep -v "${regstr}" >"${tmpffff}"
    mv "${tmpffff}" "${tmpf}"
}
more="more"
{
    . "${DN}"/../lib/libisopt
} && { echo -e "\e[33mlibisopt loaded\e[0m"; } || {
    echo -e "\e[31mFail to load libisopt.\e[0m"
    exit 1
}
mypath="${PATH}:${wd}"
IFS=":"
eachpath=(${mypath})
unset mypath
IFS=''
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
            echo "Version 2 patch 1"
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
            for dir in "${eachpath[@]}"; do
                if [ -d "${dir}" ]; then echo "${dir}/"; fi
            done
            exit 0
            ;;
        "-i" | "--invalid")
            for dir in "${eachpath[@]}"; do
                if ! [ -d "${dir}" ]; then echo "${dir}/"; fi
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
tmpf=$(mktemp -t pls.XXXXXX)
echo -e "\e[33mReading database...\e[0m"
for dir in "${eachpath[@]}"; do
    if ! [ -d "${dir}" ]; then continue ; fi
    ls -1 -F "${dir}" | sed "s;^;$(echo "${dir}")/;" >>${tmpf}
done
if ! ${allow_d}; then
    my_grep '/$'
fi
if ! ${allow_x}; then
    my_grep '\*$'
fi
if ! ${allow_o}; then
    my_grep '[^\*/]$'
fi
if [ -z "${STDS}" ]; then
    cat "${tmpf}" | ${more}
else
    IFS=" "
    STDI=(${STDS})
    IFS=''
    grepstr=''
    for fn in "${STDI[@]}"; do
        grepstr=${grepstr}" -e "${fn}
    done
    eval cat \"${tmpf}\"\|grep ${grepstr}\|${more}
fi
rm "${tmpf}"
IFS="${oldifs}"
