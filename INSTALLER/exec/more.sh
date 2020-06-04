#!/usr/bin/env bash
# MORE.sh V1P1
. "${path_sh}"
if [ -z "${mymore:-}" ]; then
    GNU_found=false
    for dir in "${eachpath[@]}"; do
        if ${GNU_found}; then
            break
        fi
        tmpf=$(mktemp -t configpath.XXXXXX)
        "${myls}" -F -1 "${dir}" | "${mygrep}" '.[*@]$' | "${mysed}" 's;[*@]$;;' | "${mygrep}" '^more\(\.exe\)*$' | "${mysed}" "s;^;$(echo ${dir})/;" >"${tmpf}"
        while read line; do
            lntmp="${line}"
            more_ver=$("${line}" --version 2>&1||true)
            if [[ "${more_ver}" =~ .*"util-linux".* ]]; then
                GNU_found=true
                type="GNU version"
            else
                type="BSD version"
            fi
            echo "more found in ${line}, ${type}"
            if ${GNU_found}; then
                echo "mymore=\"${line}\" #${type}" >>"${path_sh}"
                break
            fi
        done <"${tmpf}"
        "${myrm}" "${tmpf}"
        unset tmpf dir
    done
    . "${path_sh}"
    if [ -z "${mymore:-}" ]; then
        if [ -z "${lntmp:-}" ]; then
            echo "mymore=\"ylukh\" #UNKNOWN" >>"${path_sh}"
            echo -e "\e[31mERROR: more still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
        else
            echo -e "\e[31mWARNING: Will use BSD more, which appears to be less.\e[0m"
            echo "mymore=\"${lntmp}\" #${type}" >>"${path_sh}"
        fi
    fi
    unset more_ver line
else
    echo -e "\e[033mmore configured\e[0m"
fi
