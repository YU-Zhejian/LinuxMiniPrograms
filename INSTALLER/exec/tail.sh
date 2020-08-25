#!/usr/bin/env bash
# TAIL.sh V1P1
. "${path_sh}"
if [ -z "${mytail:-}" ]; then
    GNU_found=false
    for dir in "${eachpath[@]}"; do
        if ${GNU_found}; then
            break
        fi
        tmpf=$(mktemp -t configpath.XXXXXX)
        "${myls}" -F -1 "${dir}" | "${mygrep}" '.[*@]$' | "${mysed}" 's;[*@]$;;' | "${mygrep}" '^tail\(\.exe\)*$' | "${mysed}" "s;^;$(echo ${dir})/;" >"${tmpf}"
        while read line; do
            lntmp="${line}"
            tail_ver=$("${line}" --version 2>&1||true)
            if [[ "${tail_ver}" =~ .*"GNU".* ]]; then
                GNU_found=true
                if [[ "${tail_ver}" =~ .*"Cygwin".* ]]; then
                    type="GNU version in Cygwin systems"
                else
                    type="GNU version in GNU/Linux systems"
                fi
            else
                type="BSD version"
            fi
            echo "tail found in ${line}, ${type}"
            if ${GNU_found}; then
                echo "mytail=\"${line}\" #${type}" >>"${path_sh}"
                break
            fi
        done <"${tmpf}"
        "${myrm}" "${tmpf}"
        unset tmpf dir
    done
    . "${path_sh}"
    if [ -z "${mytail:-}" ]; then
        if [ -z "${lntmp:-}" ]; then
            echo "mytail=\"ylukh\" #UNKNOWN" >>"${path_sh}"
            echo -e "\e[31mERROR: tail still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
        else
            echo -e "\e[31mWARNING: Will use BSD tail.\e[0m"
            echo "mytail=\"${lntmp}\" #${type}" >>"${path_sh}"
        fi
    fi
    unset tail_ver line
else
    echo -e "\e[033mtail configured\e[0m"
fi
