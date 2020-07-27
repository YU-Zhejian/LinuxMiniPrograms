#!/usr/bin/env bash
# RAR.sh V1P2
. "${path_sh}"
if [ -z "${myrar:-}" ]; then
    if which rar &>>/dev/null; then
        line="$(which rar)"
        echo "myrar=\"${line}\" #UNIVERSE" >>"${path_sh}"
        echo "rar found in ${line}"
    else
        echo "myrar=\"ylukh\" #UNKNOWN" >>"${path_sh}"
        echo -e "\033[31mERROR: rar still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\033[0m"
    fi
    . "${path_sh}"
    unset line
else
    echo -e "\033[033mrar configured\033[0m"
fi
