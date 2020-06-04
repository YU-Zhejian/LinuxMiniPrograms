#!/usr/bin/env bash
# FIND.sh V1P1
. "${path_sh}"
if [ -z "${myfind:-}" ]; then
    GNU_found=false
    for dir in "${eachpath[@]}"; do
        if ${GNU_found}; then
            break
        fi
        tmpf=$(mktemp -t configpath.XXXXXX)
        "${myls}" -F -1 "${dir}" | "${mygrep}" '.[*@]$' | "${mysed}" 's;[*@]$;;' | "${mygrep}" '^find\(\.exe\)*$' | "${mysed}" "s;^;$(echo ${dir})/;" > "${tmpf}"
        while read line; do
            find_ver=$("${line}" --version 2>&1 || true)
            if [[ "${find_ver}" =~ .*"GNU".* ]]; then
                GNU_found=true
                if [[ "${find_ver}" =~ .*"Cygwin".* ]]; then
                    type="GNU version in Cygwin systems"
                else
                    type="GNU version in GNU/Linux systems"
                fi
            elif "${line}" /? &> /dev/null ;then
                type="Windows version"
            else
                lntmp="${line}"
                type="BSD version"
            fi
            echo "find found in ${line}, ${type}"
            if ${GNU_found}; then
                echo "myfind=\"${line}\" #${type}" >>"${path_sh}"
                break
            fi
        done <"${tmpf}"
        "${myrm}" "${tmpf}"
        unset tmpf dir
    done
    . "${path_sh}"
    if [ -z "${myfind:-}" ]; then
        if [ -z "${lntmp:-}" ]; then
            echo "myfind=\"ylukh\" #UNKNOWN" >>"${path_sh}"
            echo -e "\e[31mERROR: find still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
        else
            echo -e "\e[31mWARNING: Will use BSD find.\e[0m"
            echo "myfind=\"${lntmp}\" #${type}" >>"${path_sh}"
        fi
    fi
    unset find_ver line
else
    echo -e "\e[033mfind configured\e[0m"
fi
