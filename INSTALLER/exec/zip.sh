#!/usr/bin/env bash
# ZIP.sh V1P1
. "${path_sh}"
if [ -z "${myzip:-}" ]; then
    GNU_found=false
    for dir in "${eachpath[@]}"; do
        if ${GNU_found}; then
            break
        fi
        tmpf=$(mktemp -t configpath.XXXXXX)
        "${myls}" -F -1 "${dir}" | "${mygrep}" '.\*$' | "${mysed}" "s;\*\$;;" | "${mygrep}" '^zip\(\.exe\)*$' | "${mysed}" "s;^;$(echo ${dir})/;" >"${tmpf}"
        while read line; do
            lntmp="${line}"
            zip_ver=$("${line}" --version 2>&1||true)
            if [[ "${zip_ver}" =~ .*"Linux".* ]]; then
                GNU_found=true
                type="GNU version in GNU/Linux systems"
            elif [[ "${zip_ver}" =~ .*"Cygwin".* ]]; then
                GNU_found=true
                type="GNU version in Cygwin systems"
            else
                type="BSD version"
            fi
            echo "zip found in ${line}, ${type}"
            if ${GNU_found}; then
                echo "myzip=\"${line}\" #${type}" >>"${path_sh}"
                break
            fi
        done <"${tmpf}"
        "${myrm}" "${tmpf}"
        unset tmpf dir
    done
    . "${path_sh}"
    if [ -z "${myzip:-}" ]; then
        if [ -z "${lntmp:-}" ]; then
            echo "myzip=\"ylukh\" #UNKNOWN" >>"${path_sh}"
            echo -e "\e[31mERROR: zip still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
        else
            echo -e "\e[31mWARNING: Will use BSD zip.\e[0m"
            echo "myzip=\"${lntmp}\" #${type}" >>"${path_sh}"
        fi
    fi
    unset zip_ver line
else
    echo -e "\e[033mzip configured\e[0m"
fi
