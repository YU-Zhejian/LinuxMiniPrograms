#!/usr/bin/env bash
# UNRAR.sh V1P1
. "${path_sh}"
if [ -z "${myunrar:-}" ]; then
    if which unrar &>>/dev/null; then
        line="$(which unrar)"
        echo "myunrar=\"${line}\" #UNIVERSE" >>"${path_sh}"
        echo "unrar found in ${line}"
    else
        echo "myunrar=\"ylukh\" #UNKNOWN" >>"${path_sh}"
        echo -e "\033[31mERROR: unrar still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\033[0m"
    fi
    . "${path_sh}"
    unset line
else
    echo -e "\033[033munrar configured\033[0m"
fi
