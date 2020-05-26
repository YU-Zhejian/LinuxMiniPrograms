#!/usr/bin/env bash
# BGZIP.sh V1P1
if [ -z "${mybgzip:-}" ]; then
    if which bgzip &>>/dev/null; then
        line=$(which bgzip)
        echo "mybgzip=\"${line}\" #UNIVERSE" >>"${path_sh}"
        echo "bgzip found in ${line}"
    else
        echo "mybgzip=\"ylukh\" #UNKNOWN" >>"${path_sh}"
        echo -e "\e[30mERROR: bgzip still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
    fi
    . "${path_sh}"
    unset line
else
    echo -e "\e[033mbgzip configured\e[0m"
fi
