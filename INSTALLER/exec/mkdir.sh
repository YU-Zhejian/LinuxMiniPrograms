#!/usr/bin/env bash
# MKDIR.sh V1P1
. "${path_sh}"
if [ -z "${mymkdir:-}" ]; then
    GNU_found=false
    for dir in "${eachpath[@]}"; do
        if ${GNU_found}; then
            break
        fi
        tmpf=$(mktemp -t configpath.XXXXXX)
        "${myls}" -F -1 "${dir}" | "${mygrep}" '.[*@]$' | "${mysed}" 's;[*@]$;;' | "${mygrep}" '^mkdir\(\.exe\)*$' | "${mysed}" "s;^;$(echo ${dir})/;" >"${tmpf}"
        while read line; do
            lntmp="${line}"
            mkdir_ver=$("${line}" --version 2>&1||true)
            if [[ "${mkdir_ver}" =~ .*"GNU".* ]]; then
                GNU_found=true
                if [[ "${mkdir_ver}" =~ .*"Cygwin".* ]]; then
                    type="GNU version in Cygwin systems"
                else
                    type="GNU version in GNU/Linux systems"
                fi
            else
                type="BSD version"
            fi
            echo "mkdir found in ${line}, ${type}"
            if ${GNU_found}; then
                echo "mymkdir=\"${line}\" #${type}" >>"${path_sh}"
                break
            fi
        done <"${tmpf}"
        "${myrm}" "${tmpf}"
        unset tmpf dir
    done
    . "${path_sh}"
    if [ -z "${mymkdir:-}" ]; then
        if [ -z "${lntmp:-}" ]; then
            echo "mymkdir=\"ylukh\" #UNKNOWN" >>"${path_sh}"
            echo -e "\e[31mERROR: mkdir still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
        else
            echo -e "\e[31mWARNING: Will use BSD mkdir.\e[0m"
            echo "mymkdir=\"${lntmp}\" #${type}" >>"${path_sh}"
        fi
    fi
    unset mkdir_ver line
else
    echo -e "\e[033mmkdir configured\e[0m"
fi