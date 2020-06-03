#!/usr/bin/env bash
# CHOWN.sh V1P1
. "${path_sh}"
if [ -z "${mychown:-}" ]; then
    GNU_found=false
    for dir in "${eachpath[@]}"; do
        if ${GNU_found}; then
            break
        fi
        tmpf=$(mktemp -t configpath.XXXXXX)
        "${myls}" -F -1 "${dir}" | "${mygrep}" '.\*$' | "${mysed}" "s;\*\$;;" | "${mygrep}" '^chown\(\.exe\)*$' | "${mysed}" "s;^;$(echo ${dir})/;" >"${tmpf}"
        while read line; do
            lntmp="${line}"
            chown_ver=$("${line}" --version 2>&1||true)
            if [[ "${chown_ver}" =~ .*"GNU".* ]]; then
                GNU_found=true
                if [[ "${chown_ver}" =~ .*"Cygwin".* ]]; then
                    type="GNU version in Cygwin systems"
                else
                    type="GNU version in GNU/Linux systems"
                fi
            else
                type="BSD version"
            fi
            echo "chown found in ${line}, ${type}"
            if ${GNU_found}; then
                echo "mychown=\"${line}\" #${type}" >>"${path_sh}"
                break
            fi
        done <"${tmpf}"
        "${myrm}" "${tmpf}"
        unset tmpf dir
    done
    . "${path_sh}"
    if [ -z "${mychown:-}" ]; then
        if [ -z "${lntmp:-}" ]; then
            echo "mychown=\"ylukh\" #UNKNOWN" >>"${path_sh}"
            echo -e "\e[31mERROR: chown still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
        else
            echo -e "\e[31mWARNING: Will use BSD chown.\e[0m"
            echo "mychown=\"${lntmp}\" #${type}" >>"${path_sh}"
        fi
    fi
    unset chown_ver line
else
    echo -e "\e[033mchown configured\e[0m"
fi
