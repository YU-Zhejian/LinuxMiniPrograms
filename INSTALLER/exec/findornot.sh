#!/usr/bin/env bash
# FINDORNOT.sh V2
if ! "${mygrep}" ^"${PROGNAME}"= "${path_sh}";then
    if which "${PROGNAME}" &>>/dev/null; then
        line="$(which "${PROGNAME}")"
        echo "my${PROGNAME}=\"${line}\" #UNIVERSE" >>"${path_sh}"
        echo "${PROGNAME} found in ${line}"
    else
        echo "my${PROGNAME}=\"ylukh\" #UNKNOWN" >>"${path_sh}"
        echo -e "\033[31mERROR: ${PROGNAME} still not found. Please configure it manually in LMP_ROOT/etc/"${path_sh}".\033[0m"
    fi
    unset line
else
    echo -e "\033[033m${PROGNAME} configured\033[0m"
fi
