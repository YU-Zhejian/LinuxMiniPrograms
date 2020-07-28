#!/usr/bin/env bash
# unzip.sh V1P1
. "${path_sh}"
if [ -z "${myunzip:-}" ]; then
    GNU_found=false
    for dir in "${eachpath[@]}"; do
        if ${GNU_found}; then
            break
        fi
        tmpf=$(mktemp -t configpath.XXXXXX)
        "${myls}" -F -1 "${dir}" | "${mygrep}" '.[*@]$' | "${mysed}" 's;[*@]$;;' | "${mygrep}" '^unzip\(\.exe\)*$' | "${mysed}" "s;^;$(echo ${dir})/;" >"${tmpf}"
        while read line; do
            lntmp="${line}"
            unzip_ver=$("${line}" -v 2>&1||true)
            if [[ "${unzip_ver}" =~ .*"Linux".* ]]; then
                GNU_found=true
                type="GNU version in GNU/Linux systems"
            elif [[ "${unzip_ver}" =~ .*"Cygwin".* ]]; then
                GNU_found=true
                type="GNU version in Cygwin systems"
            else
                type="BSD version"
            fi
            echo "unzip found in ${line}, ${type}"
            if ${GNU_found}; then
                echo "myunzip=\"${line}\" #${type}" >>"${path_sh}"
                break
            fi
        done <"${tmpf}"
        "${myrm}" "${tmpf}"
        unset tmpf dir
    done
    . "${path_sh}"
    if [ -z "${myunzip:-}" ]; then
        if [ -z "${lntmp:-}" ]; then
            echo "myunzip=\"ylukh\" #UNKNOWN" >>"${path_sh}"
            echo -e "\033[31mERROR: unzip still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\033[0m"
        else
            echo -e "\033[31mWARNING: Will use BSD unzip.\033[0m"
            echo "myunzip=\"${lntmp}\" #${type}" >>"${path_sh}"
        fi
    fi
    unset unzip_ver line
else
    echo -e "\033[033munzip configured\033[0m"
fi
