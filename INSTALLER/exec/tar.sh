#!/usr/bin/env bash
# TAR.sh V1P1
if [ -z "${mytar:-}" ]; then
    GNU_found=false
    for dir in "${eachpath[@]}"; do
        if ${GNU_found}; then
            break
        fi
        tmpf=$(mktemp -t configpath.XXXXXX)
        "${myls}" -F -1 "${dir}" | "${mygrep}" '.\*$' | "${mysed}" "s;\*\$;;" | "${mygrep}" '^tar\(\.exe\)*$' | "${mysed}" "s;^;$(echo ${dir})/;" >"${tmpf}"
        while read line; do
            tar_ver=$("${line}" --version 2>&1)
            if [[ "${tar_ver}" =~ .*"GNU".* ]]; then
                GNU_found=true
                if [[ "${tar_ver}" =~ .*"Cygwin".* ]]; then
                    type="GNU version in Cygwin systems"
                else
                    type="GNU version in GNU/Linux systems"
                fi
            else
                type="BSD version"
            fi
            echo "tar found in ${line}, ${type}"
            if ${GNU_found}; then
                echo "mytar=\"${line}\" #${type}" >>"${path_sh}"
                break
            fi
            unset type
        done <"${tmpf}"
        "${myrm}" "${tmpf}"
        unset tmpf dir
    done
    . "${path_sh}"
    if [ -z "${mytar:-}" ]; then
        if [ -z "${line:-}" ]; then
            echo "mytar=\"ylukh\" #UNKNOWN" >>"${path_sh}"
            echo -e "\e[30mERROR: tar still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
        else
            echo -e "\e[30mWARNING: Will use BSD tar.\e[0m"
            echo "mytar=\"${line}\" #${type}" >>"${path_sh}"
        fi
    fi
    unset tar_ver line
else
    echo -e "\e[033mtar configured\e[0m"
fi
