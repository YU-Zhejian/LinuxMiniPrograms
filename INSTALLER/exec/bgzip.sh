#!/usr/bin/env bash
# BGZIP.sh V1P1
. "${path_sh}"
if [ -z "${mybgzip:-}" ]; then
    if which bgzip &>>/dev/null; then
        line="$(which bgzip)"
        echo "mybgzip=\"${line}\" #UNIVERSE" >>"${path_sh}"
        echo "bgzip found in ${line}"
    else
        echo "mybgzip=\"ylukh\" #UNKNOWN" >>"${path_sh}"
        echo -e "\033[31mERROR: bgzip still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\033[0m"
    fi
    . "${path_sh}"
    unset line
else
    echo -e "\033[033mbgzip configured\033[0m"
fi
