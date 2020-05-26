#!/usr/bin/env bash
# RM.sh V1P1
if [ -z "${myrm:-}" ]; then
    GNU_found=false
    for dir in "${eachpath[@]}"; do
        if ${GNU_found}; then
            break
        fi
        tmpf=$(mktemp -t configpath.XXXXXX)
        ${myls} -F -1 "${dir}" | ${mygrep} '.\*$' | ${mysed} "s;\*\$;;" | ${mygrep} '^rm\(\.exe\)*$' | ${mysed} "s;^;$(echo ${dir})/;" >"${tmpf}"
        while read line; do
            rm_ver=$("${line}" --version 2>&1)
            if [[ "${rm_ver}" =~ .*"GNU".* ]]; then
                GNU_found=true
                if [[ "${rm_ver}" =~ .*"Cygwin".* ]]; then
                    type="GNU version in Cygwin systems"
                else
                    type="GNU version in GNU/Linux systems"
                fi
            else
                type="BSD version"
            fi
            echo "rm found in ${line}, ${type}"
            if ${GNU_found}; then
                echo "myrm=\"${line}\" #${type}" >>"${path_sh}"
                break
            fi
            unset type
        done <"${tmpf}"
        rm "${tmpf}"
        unset tmpf dir
    done
    . "${path_sh}"
    if [ -z "${myrm:-}" ]; then
        if [ -z "${line:-}" ]; then
            echo "myrm=\"ylukh\" #UNKNOWN" >>"${path_sh}"
            echo -e "\e[30mERROR: rm still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
        else
            echo -e "\e[30mWARNING: Will use BSD rm.\e[0m"
            echo "myrm=\"${line}\" #${type}" >>"${path_sh}"
        fi
    fi
    unset rm_ver line
else
    echo -e "\e[033mrm configured\e[0m"
fi
