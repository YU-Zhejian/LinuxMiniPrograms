#!/usr/bin/env bash
# PIGZ.sh V1P1
. "${path_sh}"
if [ -z "${mypigz:-}" ]; then
    if which pigz &>>/dev/null; then
        line="$(which pigz)"
        echo "mypigz=\"${line}\" #UNIVERSE" >>"${path_sh}"
        echo "pigz found in ${line}"
    else
        echo "mypigz=\"ylukh\" #UNKNOWN" >>"${path_sh}"
        echo -e "\e[31mERROR: pigz still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
    fi
    . "${path_sh}"
    unset line
else
    echo -e "\e[033mpigz configured\e[0m"
fi
