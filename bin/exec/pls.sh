#!/usr/bin/env bash
# PLS V3
set -eu
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
. "${DN}"/../lib/libisopt
. "${DN}"/../lib/libpath
IFS=":"
eachpath=(${valid_path})
unset duplicated_path
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
            echo "Version 3 in Bash"
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
            echo ${valid_path} | tr ':' '\n'
            unset valid_path
            exit 0
            ;;
        "-i" | "--invalid")
            echo ${invalid_path} | tr ':' '\n'
            unset invalid_set invalid_path valid_path
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
unset invalid_path valid_path
tmpf=$(mktemp -t pls.XXXXXX)
echo -e "\e[33mReading database...\e[0m"
for dir in "${eachpath[@]}"; do
    if ! [ -d "${dir}" ]; then continue; fi
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
if [ -z "${STDS:-}" ]; then
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
