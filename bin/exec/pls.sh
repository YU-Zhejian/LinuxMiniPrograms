#!/usr/bin/env bash
# PLS V3P2
oldifs="${IFS}"
function my_grep() {
    regstr="${1}"
    local tmpffff=$(mktemp -t pls.XXXXXX)
    "${mycat}" "${tmpf}" | "${mygrep}" -v "${regstr}" >"${tmpffff}"
    mv "${tmpffff}" "${tmpf}"
}
more="${mymore}"
. "${DN}"/../lib/libisopt
INPATH="${PATH}"
. "${DN}"/../lib/libpath
IFS=":"
eachpath=(${valid_path})
unset duplicated_path
IFS=''
allow_x=true
allow_d=false
allow_o=true
STDS=()
for opt in "${@}"; do
    if isopt "${opt}"; then
        case "${opt}" in
        "-h" | "--help")
            yldoc pls
            exit 0
            ;;
        "-v" | "--version")
            echo "Version 3 Patch 1 in Bash"
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
            more=$"{opt:7}"
            if $("${more}" --help &>/dev/null;echo ${?}) -eq 127; then
                echo -e "\033[31mERROR! Invalid More '${more}'! Will use original '${mymore}' instead.\033[0m"
                more="${mymore}"
            else
                echo -e "\033[33mWill use '${more}' as More.\033[0m"
            fi
            ;;
        *)
            echo -e "\033[31mERROR: Option '${opt}' invalid.\033[0m"
            exit 1
            ;;
        esac
    else
        STDS=("${STDS[@]}" "${opt}")
    fi
done
unset invalid_path valid_path
tmpf="$(mktemp -t pls.XXXXXX)"
echo -e "\033[33mReading database...\033[0m"
for dir in "${eachpath[@]}"; do
    ! [ -d "${dir}" ] && continue || true
    "${myls}" -1 -F "${dir}" | "${mysed}" "s;^;$(echo "${dir}")/;" >>"${tmpf}"
done
! ${allow_d} && my_grep '/$' || true
! ${allow_x} && my_grep '\*$' || true
! ${allow_o} && my_grep '[^\*/]$' || true
if [ ${#STDS[@]} -eq 0 ]; then
    "${mycat}" "${tmpf}" | "${more}"
else
    IFS=''
    grepstr=''
    for fn in "${STDS[@]}"; do
        grepstr="${grepstr} -e ${fn}"
    done
    eval "${mycat}" \"${tmpf}\"\|"${mygrep}" "${grepstr}"\|"${more}"
fi
rm "${tmpf}"
IFS="${oldifs}"
