#!/usr/bin/env bash
# PARALLEL.sh V1P1
if [ -z "${myparallel:-}" ]; then
    GNU_found=false
    for dir in "${eachpath[@]}"; do
        if ${GNU_found}; then
            break
        fi
        tmpf=$(mktemp -t configpath.XXXXXX)
        "${myls}" -F -1 "${dir}" | "${mygrep}" '.\*$' | "${mysed}" "s;\*\$;;" | "${mygrep}" '^parallel\(\.exe\)*$' | "${mysed}" "s;^;$(echo ${dir})/;" >"${tmpf}"
        while read line; do
            echo "will cite\n" | "${line}" --citation &>>/dev/null
            parallel_ver=$("${line}" --version 2>&1)
            if [[ "${parallel_ver}" =~ .*"GNU".* ]]; then
                GNU_found=true
                type="GNU version"
            fi
            echo "parallel found in ${line}, ${type}"
            if ${GNU_found}; then
                echo "myparallel=\"${line}\" #${type}" >>"${path_sh}"
                break
            fi
            unset type
        done <"${tmpf}"
        "${myrm}" "${tmpf}"
        unset tmpf dir
    done
    . "${path_sh}"
    if [ -z "${myparallel:-}" ]; then
        echo "myparallel=\"ylukh\" #UNKNOWN" >>"${path_sh}"
        echo -e "\e[30mERROR: parallel still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
    fi
    unset parallel_ver line
else
    echo -e "\e[033mparallel configured\e[0m"
fi
