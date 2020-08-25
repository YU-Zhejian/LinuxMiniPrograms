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
        echo -e "\e[31mERROR: unrar still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
    fi
    . "${path_sh}"
    unset line
else
    echo -e "\e[033munrar configured\e[0m"
fi
