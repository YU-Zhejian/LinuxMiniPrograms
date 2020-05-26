#!/usr/bin/env bash
# 7Z.sh V1P1
if [ -z "${my7z:-}" ]; then
    if which 7za&>>/dev/null; then
        line=$(which 7za)
        echo "my7z=\"${line}\" #UNIVERSE" >>"${path_sh}"
        echo "7z found in ${line}"
    else
        echo "my7z=\"ylukh\" #UNKNOWN" >>"${path_sh}"
        echo -e "\e[30mERROR: 7z still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
    fi
    . "${path_sh}"
    unset line
else
    echo -e "\e[033m7z configured\e[0m"
fi
