#!/usr/bin/env bash
# RAR.sh V1P1
if [ -z "${rar:-}" ]; then
    if which unrar &>>/dev/null; then
        line=$(which unrar)
        echo "rar=\"${line}\" #UNIVERSE" >>"${path_sh}"
        echo "unrar found in ${line}"
    else
        echo "rar=\"ylukh\" #UNKNOWN" >>"${path_sh}"
        echo -e "\e[30mERROR: unrar still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
    fi
    . "${path_sh}"
    unset line
else
    echo -e "\e[033munrar configured\e[0m"
fi
