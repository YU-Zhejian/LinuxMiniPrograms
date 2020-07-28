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
        echo -e "\033[31mERROR: pigz still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\033[0m"
    fi
    . "${path_sh}"
    unset line
else
    echo -e "\033[033mpigz configured\033[0m"
fi
