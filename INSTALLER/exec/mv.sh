#!/usr/bin/env bash
# MV.sh V1
if [ -z "${mymv:-}" ]; then
    GNU_found=false
    for dir in "${eachpath[@]}"; do
        if ${GNU_found}; then
            break
        fi
        tmpf=$(mktemp -t configpath.XXXXXX)
        ${myls} -F -1 "${dir}" | ${mygrep} '.\*$' | ${mysed} "s;\*\$;;" | ${mygrep} '^mv\(\.exe\)*$' | ${mysed} "s;^;$(echo ${dir})/;" >"${tmpf}"
        while read line; do
            mv_ver=$("${line}" --version 2>&1)
            if [[ "${mv_ver}" =~ .*"GNU".* ]]; then
                GNU_found=true
                if [[ "${mv_ver}" =~ .*"Cygwin".* ]]; then
                    type="GNU version in Cygwin systems"
                else
                    type="GNU version in GNU/Linux systems"
                fi
            else
                type="BSD version"
            fi
            echo "mv found in ${line}, ${type}"
            if ${GNU_found}; then
                echo "mymv=\"${line}\" #${type}" >>"${path_sh}"
                break
            fi
            unset type
        done <"${tmpf}"
        rm "${tmpf}"
        unset tmpf dir
    done
    . "${path_sh}"
    if [ -z "${mymv:-}" ]; then
        if [ -z "${line:-}" ]; then
            echo "mymv=\"mv\" #UNKNOWN" >>"${path_sh}"
            echo -e "\e[30mERROR: mv still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
        else
            echo -e "\e[30mWARNING: Will use BSD mv.\e[0m"
            echo "mymv=\"${line}\" #${type}" >>"${path_sh}"
        fi
    fi
    unset mv_ver line
else
    echo -e "\e[033mmv configured\e[0m"
fi
