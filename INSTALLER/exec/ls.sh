#!/usr/bin/env bash
# LS.sh V1P1
if [ -z "${myls:-}" ]; then
    GNU_found=false
    for dir in "${eachpath[@]}"; do
        if ${GNU_found}; then
            break
        fi
        tmpf=$(mktemp -t configpath.XXXXXX)
        ls -F -1 "${dir}" | grep '.\*$' | sed "s;\*\$;;" | grep '^ls\(\.exe\)*$' | sed "s;^;$(echo ${dir})/;" >"${tmpf}"
        while read line; do
            lntmp="${line}"
            ls_ver=$("${line}" --version 2>&1)
            if [[ "${ls_ver}" =~ .*"GNU".* ]]; then
                GNU_found=true
                if [[ "${ls_ver}" =~ .*"Cygwin".* ]]; then
                    type="GNU version in Cygwin systems"
                else
                    type="GNU version in GNU/Linux systems"
                fi
            else
                type="BSD version"
            fi
            echo "ls found in ${line}, ${type}"
            if ${GNU_found}; then
                echo "myls=\"${line}\" #${type}" >>path.sh
                break
            fi
        done <"${tmpf}"
        rm "${tmpf}"
        unset tmpf dir
    done
    . "${path_sh}"
    if [ -z "${myls:-}" ]; then
        if [ -z "${lntmp:-}" ]; then
            echo "myls=\"ylukh\" #UNKNOWN" >>path.sh
            echo -e "\e[30mERROR: ls still not found. Please configure it manually in LMP_ROOT/etc/path.sh.\e[0m"
        else
            echo -e "\e[30mWARNING: Will use BSD ls.\e[0m"
            echo "myls=\"${lntmp}\" #${type}" >>path.sh
        fi
    fi
    unset ls_ver line
else
    echo -e "\e[033mls configured\e[0m"
fi
