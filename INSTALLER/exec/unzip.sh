#!/usr/bin/env bash
# unzip.sh V1P1
if [ -z "${myunzip:-}" ]; then
    GNU_found=false
    for dir in "${eachpath[@]}"; do
        if ${GNU_found}; then
            break
        fi
        tmpf=$(mktemp -t configpath.XXXXXX)
        ${myls} -F -1 "${dir}" | ${mygrep} '.\*$' | ${mysed} "s;\*\$;;" | ${mygrep} '^unzip\(\.exe\)*$' | ${mysed} "s;^;$(echo ${dir})/;" >"${tmpf}"
        while read line; do
            unzip_ver=$("${line}" -v 2>&1)
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
            unset type
        done <"${tmpf}"
        rm "${tmpf}"
        unset tmpf dir
    done
    . "${path_sh}"
    if [ -z "${myunzip:-}" ]; then
        if [ -z "${line:-}" ]; then
            echo "myunzip=\"ylukh\" #UNKNOWN" >>"${path_sh}"
            echo -e "\e[30mERROR: unzip still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
        else
            echo -e "\e[30mWARNING: Will use BSD unzip.\e[0m"
            echo "myunzip=\"${line}\" #${type}" >>"${path_sh}"
        fi
    fi
    unset unzip_ver line
else
    echo -e "\e[033munzip configured\e[0m"
fi
