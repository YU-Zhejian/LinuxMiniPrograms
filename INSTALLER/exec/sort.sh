#!/usr/bin/env bash
# SORT.sh V1P1
if [ -z "${mysort:-}" ]; then
    GNU_found=false
    for dir in "${eachpath[@]}"; do
        if ${GNU_found}; then
            break
        fi
        tmpf=$(mktemp -t configpath.XXXXXX)
        "${myls}" -F -1 "${dir}" | "${mygrep}" '.\*$' | "${mysed}" "s;\*\$;;" | "${mygrep}" '^sort\(\.exe\)*$' | "${mysed}" "s;^;$(echo ${dir})/;" >"${tmpf}"
        while read line; do
            sort_ver=$("${line}" --version 2>&1||true)
            if [[ "${sort_ver}" =~ .*"GNU".* ]]; then
                GNU_found=true
                if [[ "${sort_ver}" =~ .*"Cygwin".* ]]; then
                    type="GNU version in Cygwin systems"
                else
                    type="GNU version in GNU/Linux systems"
                fi
            elif "${line}" /? &> /dev/null ;then
                type="Windows version"
            else
                type="BSD version"
            fi
            echo "sort found in ${line}, ${type}"
            if ${GNU_found}; then
                echo "mysort=\"${line}\" #${type}" >>"${path_sh}"
                break
            fi
            unset type
        done <"${tmpf}"
        "${myrm}" "${tmpf}"
        unset tmpf dir
    done
    . "${path_sh}"
    if [ -z "${mysort:-}" ]; then
        if [ -z "${line:-}" ]; then
            echo "mysort=\"ylukh\" #UNKNOWN" >>"${path_sh}"
            echo -e "\e[30mERROR: sort still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
        else
            echo -e "\e[30mWARNING: Will use BSD sort.\e[0m"
            echo "mysort=\"${line}\" #${type}" >>"${path_sh}"
        fi
    fi
    unset sort_ver line
else
    echo -e "\e[033msort configured\e[0m"
fi
