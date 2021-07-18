#!/usr/bin/env bash
# shellcheck disable=SC2034
VERSION=2.4
# shellcheck disable=SC2154
if ! grep "^my${PROGNAME}=" "${path_sh}"; then
    if which "${PROGNAME}" &>>/dev/null; then
        line="$(which "${PROGNAME}")"
        builtin echo "my${PROGNAME}=\"${line}\" #UNIVERSE" >>"${path_sh}"
        builtin echo "${PROGNAME} found in ${line}"
    else
        builtin echo "my${PROGNAME}=\"ylukh\" #UNKNOWN" >>"${path_sh}"
        warnh "${PROGNAME} still not found. Please configure it manually in $(readlink -f "${path_sh}")"
    fi
    builtin unset line
else
    infoh "${PROGNAME} configured"
fi
