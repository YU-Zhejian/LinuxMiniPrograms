#!/usr/bin/env bash
# SPLIT.sh V1P1
if [ -z "${mysplit:-}" ]; then
    GNU_found=false
    for dir in "${eachpath[@]}"; do
        if ${GNU_found}; then
            break
        fi
        tmpf=$(mktemp -t configpath.XXXXXX)
        "${myls}" -F -1 "${dir}" | "${mygrep}" '.\*$' | "${mysed}" "s;\*\$;;" | "${mygrep}" '^split\(\.exe\)*$' | "${mysed}" "s;^;$(echo ${dir})/;" >"${tmpf}"
        while read line; do
            split_ver=$("${line}" --version 2>&1)
            if [[ "${split_ver}" =~ .*"GNU".* ]]; then
                GNU_found=true
                if [[ "${split_ver}" =~ .*"Cygwin".* ]]; then
                    type="GNU version in Cygwin systems"
                else
                    type="GNU version in GNU/Linux systems"
                fi
            else
                type="BSD version"
            fi
            echo "split found in ${line}, ${type}"
            if ${GNU_found}; then
                echo "mysplit=\"${line}\" #${type}" >>"${path_sh}"
                break
            fi
            unset type
        done <"${tmpf}"
        "${myrm}" "${tmpf}"
        unset tmpf dir
    done
    . "${path_sh}"
    if [ -z "${mysplit:-}" ]; then
        if [ -z "${line:-}" ]; then
            echo "mysplit=\"ylukh\" #UNKNOWN" >>"${path_sh}"
            echo -e "\e[30mERROR: split still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
        else
            echo -e "\e[30mWARNING: Will use BSD split.\e[0m"
            echo "mysplit=\"${line}\" #${type}" >>"${path_sh}"
        fi
    fi
    unset split_ver line
else
    echo -e "\e[033msplit configured\e[0m"
fi
