#!/usr/bin/env bash
# XZIP.sh V1P1
. "${path_sh}"
if [ -z "${myxzip:-}" ]; then
    if xz --help &>>/dev/null; then
        line="$(which xz)"
        echo "myxzip=\"${line}\" #UNIVERSE" >>"${path_sh}"
        echo "xzip found in ${line}"
    else
        echo "myxzip=\"ylukh\" #UNKNOWN" >>"${path_sh}"
        echo -e "\e[31mERROR: xzip still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\e[0m"
    fi
    . "${path_sh}"
    unset line
else
    echo -e "\e[033mxzip configured\e[0m"
fi
