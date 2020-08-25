#!/usr/bin/env bash
# CAT.sh V1P1
. "${path_sh}"
if [ -z "${mycat:-}" ]; then
    GNU_found=false
    for dir in "${eachpath[@]}"; do
        if ${GNU_found}; then
            break
        fi
        tmpf=$(mktemp -t configpath.XXXXXX)
        "${myls}" -F -1 "${dir}" | "${mygrep}" '.[*@]$' | "${mysed}" 's;[*@]$;;' | "${mygrep}" '^cat\(\.exe\)*$' | "${mysed}" "s;^;$(echo ${dir})/;" >"${tmpf}"
        while read line; do
            lntmp="${line}"
            cat_ver=$("${line}" --version 2>&1||true)
            if [[ "${cat_ver}" =~ .*"GNU".* ]]; then
                GNU_found=true
                if [[ "${cat_ver}" =~ .*"Cygwin".* ]]; then
                    type="GNU version in Cygwin systems"
                else
                    type="GNU version in GNU/Linux systems"
                fi
            else
                type="BSD version"
            fi
            echo "cat found in ${line}, ${type}"
            if ${GNU_found}; then
                echo "mycat=\"${line}\" #${type}" >>"${path_sh}"
                break
            fi
        done <"${tmpf}"
        "${myrm}" "${tmpf}"
        unset tmpf dir
    done
    . "${path_sh}"
    if [ -z "${mycat:-}" ]; then
        if [ -z "${lntmp:-}" ]; then
            echo "mycat=\"ylukh\" #UNKNOWN" >>"${path_sh}"
            echo -e "\e[31mERROR: cat still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
        else
            echo -e "\e[31mWARNING: Will use BSD cat.\e[0m"
            echo "mycat=\"${lntmp}\" #${type}" >>"${path_sh}"
        fi
    fi
    unset cat_ver line
else
    echo -e "\e[033mcat configured\e[0m"
fi
