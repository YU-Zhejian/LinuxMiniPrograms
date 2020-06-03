#!/usr/bin/env bash
# CHMOD.sh V1P1
. "${path_sh}"
if [ -z "${mychmod:-}" ]; then
    GNU_found=false
    for dir in "${eachpath[@]}"; do
        if ${GNU_found}; then
            break
        fi
        tmpf=$(mktemp -t configpath.XXXXXX)
        "${myls}" -F -1 "${dir}" | "${mygrep}" '.\*$' | "${mysed}" "s;\*\$;;" | "${mygrep}" '^chmod\(\.exe\)*$' | "${mysed}" "s;^;$(echo ${dir})/;" >"${tmpf}"
        while read line; do
            lntmp="${line}"
            chmod_ver=$("${line}" --version 2>&1||true)
            if [[ "${chmod_ver}" =~ .*"GNU".* ]]; then
                GNU_found=true
                if [[ "${chmod_ver}" =~ .*"Cygwin".* ]]; then
                    type="GNU version in Cygwin systems"
                else
                    type="GNU version in GNU/Linux systems"
                fi
            else
                type="BSD version"
            fi
            echo "chmod found in ${line}, ${type}"
            if ${GNU_found}; then
                echo "mychmod=\"${line}\" #${type}" >>"${path_sh}"
                break
            fi
        done <"${tmpf}"
        "${myrm}" "${tmpf}"
        unset tmpf dir
    done
    . "${path_sh}"
    if [ -z "${mychmod:-}" ]; then
        if [ -z "${lntmp:-}" ]; then
            echo "mychmod=\"ylukh\" #UNKNOWN" >>"${path_sh}"
            echo -e "\e[31mERROR: chmod still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
        else
            echo -e "\e[31mWARNING: Will use BSD chmod.\e[0m"
            echo "mychmod=\"${lntmp}\" #${type}" >>"${path_sh}"
        fi
    fi
    unset chmod_ver line
else
    echo -e "\e[033mchmod configured\e[0m"
fi
