#!/usr/bin/env bash
# GZIP.sh V1P1
if [ -z "${mygzip:-}" ]; then
    GNU_found=false
    for dir in "${eachpath[@]}"; do
        if ${GNU_found}; then
            break
        fi
        tmpf=$(mktemp -t configpath.XXXXXX)
        ${myls} -F -1 "${dir}" | ${mygrep} '.\*$' | ${mysed} "s;\*\$;;" | ${mygrep} '^gzip\(\.exe\)*$' | ${mysed} "s;^;$(echo ${dir})/;" >"${tmpf}"
        while read line; do
            gzip_ver=$("${line}" --version 2>&1)
            if [[ "${gzip_ver}" =~ .*"GNU".* ]]; then
                GNU_found=true
                type="GNU version"
            else
                type="BSD version"
            fi
            echo "gzip found in ${line}, ${type}"
            if ${GNU_found}; then
                echo "mygzip=\"${line}\" #${type}" >>"${path_sh}"
                break
            fi
            unset type
        done <"${tmpf}"
        rm "${tmpf}"
        unset tmpf dir
    done
    . "${path_sh}"
    if [ -z "${mygzip:-}" ]; then
        if [ -z "${line:-}" ]; then
            echo "mygzip=\"ylukh\" #UNKNOWN" >>"${path_sh}"
            echo -e "\e[30mERROR: gzip still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
        else
            echo -e "\e[30mWARNING: Will use BSD gzip.\e[0m"
            echo "mygzip=\"${line}\" #${type}" >>"${path_sh}"
        fi
    fi
    unset gzip_ver line
else
    echo -e "\e[033mgzip configured\e[0m"
fi
