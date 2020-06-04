#!/usr/bin/env bash
# RAR.sh V1P1
. "${path_sh}"
if [ -z "${myrar:-}" ]; then
    if which rar &>>/dev/null; then
        line="$(which rar)"
        echo "myrar=\"${line}\" #UNIVERSE" >>"${path_sh}"
        echo "rar found in ${line}"
    else
        echo "myrar=\"ylukh\" #UNKNOWN" >>"${path_sh}"
        echo -e "\e[31mERROR: myrar still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
    fi
    . "${path_sh}"
    unset line
else
    echo -e "\e[033mmyrar configured\e[0m"
fi
