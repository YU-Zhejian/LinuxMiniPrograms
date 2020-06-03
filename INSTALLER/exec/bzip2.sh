#!/usr/bin/env bash
# BZIP2.sh V1P1
. "${path_sh}"
if [ -z "${mybzip2:-}" ]; then
    if which bzip2 &>>/dev/null; then
        line="$(which bzip2)"
        echo "mybzip2=\"${line}\" #UNIVERSE" >>"${path_sh}"
        echo "bzip2 found in ${line}"
    else
        echo "mybzip2=\"ylukh\" #UNKNOWN" >>"${path_sh}"
        echo -e "\e[31mERROR: bzip2 still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
    fi
    . "${path_sh}"
    unset line
else
    echo -e "\e[033mbzip2 configured\e[0m"
fi

