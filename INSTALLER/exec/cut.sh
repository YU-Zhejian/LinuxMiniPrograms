#!/usr/bin/env bash
# CUT.sh V1P1
. "${path_sh}"
if [ -z "${mycut:-}" ]; then
    GNU_found=false
    for dir in "${eachpath[@]}"; do
        if ${GNU_found}; then
            break
        fi
        tmpf=$(mktemp -t configpath.XXXXXX)
        "${myls}" -F -1 "${dir}" | "${mygrep}" '.[*@]$' | "${mysed}" 's;[*@]$;;' | "${mygrep}" '^cut\(\.exe\)*$' | "${mysed}" "s;^;$(echo ${dir})/;" >"${tmpf}"
        while read line; do
            lntmp="${line}"
            cut_ver=$("${line}" --version 2>&1||true)
            if [[ "${cut_ver}" =~ .*"GNU".* ]]; then
                GNU_found=true
                if [[ "${cut_ver}" =~ .*"Cygwin".* ]]; then
                    type="GNU version in Cygwin systems"
                else
                    type="GNU version in GNU/Linux systems"
                fi
            else
                type="BSD version"
            fi
            echo "cut found in ${line}, ${type}"
            if ${GNU_found}; then
                echo "mycut=\"${line}\" #${type}" >>"${path_sh}"
                break
            fi
        done <"${tmpf}"
        "${myrm}" "${tmpf}"
        unset tmpf dir
    done
    . "${path_sh}"
    if [ -z "${mycut:-}" ]; then
        if [ -z "${lntmp:-}" ]; then
            echo "mycut=\"ylukh\" #UNKNOWN" >>"${path_sh}"
            echo -e "\e[31mERROR: cut still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
        else
            echo -e "\e[31mWARNING: Will use BSD cut.\e[0m"
            echo "mycut=\"${lntmp}\" #${type}" >>"${path_sh}"
        fi
    fi
    unset cut_ver line
else
    echo -e "\e[033mcut configured\e[0m"
fi
