#!/usr/bin/env bash
# HEAD.sh V1P1
. "${path_sh}"
if [ -z "${myhead:-}" ]; then
    GNU_found=false
    for dir in "${eachpath[@]}"; do
        if ${GNU_found}; then
            break
        fi
        tmpf=$(mktemp -t configpath.XXXXXX)
        "${myls}" -F -1 "${dir}" | "${mygrep}" '.\*$' | "${mysed}" "s;\*\$;;" | "${mygrep}" '^head\(\.exe\)*$' | "${mysed}" "s;^;$(echo ${dir})/;" >"${tmpf}"
        while read line; do
            lntmp="${line}"
            head_ver=$("${line}" --version 2>&1||true)
            if [[ "${head_ver}" =~ .*"GNU".* ]]; then
                GNU_found=true
                if [[ "${head_ver}" =~ .*"Cygwin".* ]]; then
                    type="GNU version in Cygwin systems"
                else
                    type="GNU version in GNU/Linux systems"
                fi
            else
                type="BSD version"
            fi
            echo "head found in ${line}, ${type}"
            if ${GNU_found}; then
                echo "myhead=\"${line}\" #${type}" >>"${path_sh}"
                break
            fi
        done <"${tmpf}"
        "${myrm}" "${tmpf}"
        unset tmpf dir
    done
    . "${path_sh}"
    if [ -z "${myhead:-}" ]; then
        if [ -z "${lntmp:-}" ]; then
            echo "myhead=\"ylukh\" #UNKNOWN" >>"${path_sh}"
            echo -e "\e[31mERROR: head still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
        else
            echo -e "\e[31mWARNING: Will use BSD head.\e[0m"
            echo "myhead=\"${lntmp}\" #${type}" >>"${path_sh}"
        fi
    fi
    unset head_ver line
else
    echo -e "\e[033mhead configured\e[0m"
fi
