#!/usr/bin/env bash
# CP.sh V1P1
. "${path_sh}"
if [ -z "${mycp:-}" ]; then
    GNU_found=false
    for dir in "${eachpath[@]}"; do
        if ${GNU_found}; then
            break
        fi
        tmpf=$(mktemp -t configpath.XXXXXX)
        "${myls}" -F -1 "${dir}" | "${mygrep}" '.[*@]$' | "${mysed}" 's;[*@]$;;' | "${mygrep}" '^cp\(\.exe\)*$' | "${mysed}" "s;^;$(echo ${dir})/;" >"${tmpf}"
        while read line; do
            lntmp="${line}"
            cp_ver=$("${line}" --version 2>&1||true)
            if [[ "${cp_ver}" =~ .*"GNU".* ]]; then
                GNU_found=true
                if [[ "${cp_ver}" =~ .*"Cygwin".* ]]; then
                    type="GNU version in Cygwin systems"
                else
                    type="GNU version in GNU/Linux systems"
                fi
            else
                type="BSD version"
            fi
            echo "cp found in ${line}, ${type}"
            if ${GNU_found}; then
                echo "mycp=\"${line}\" #${type}" >>"${path_sh}"
                break
            fi
        done <"${tmpf}"
        "${myrm}" "${tmpf}"
        unset tmpf dir
    done
    . "${path_sh}"
    if [ -z "${mycp:-}" ]; then
        if [ -z "${lntmp:-}" ]; then
            echo "mycp=\"ylukh\" #UNKNOWN" >>"${path_sh}"
            echo -e "\033[31mERROR: cp still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\033[0m"
        else
            echo -e "\033[31mWARNING: Will use BSD cp.\033[0m"
            echo "mycp=\"${lntmp}\" #${type}" >>"${path_sh}"
        fi
    fi
    unset cp_ver line
else
    echo -e "\033[033mcp configured\033[0m"
fi
