#!/usr/bin/env bash

if [ -z "${__LIBNET_VERSION:-}" ];then
    __LIBNET_VERSION=1.5
    IP_ADDR=()

    # Need libstr
    getIpAddr() {
        tmp="$(mktemp "ipaddr.XXXXX")"
        if which ip &>>/dev/null; then
            ip addr | grep inet | grep -v inet6 >"${tmp}"
        elif which ifconfig &>>/dev/null; then
            ifconfig | grep inet | grep -v inet6 >"${tmp}"
        else
            errh "Need command 'ip' or 'ifconfig'."
        fi
        while builtin read line; do
            : trimstr "${line}" | cut -d ' ' -f 2
            IP_ADDR=("${IP_ADDR[@]}" "${_}")
        done <"${tmp}"
        rm "${tmp}"
    }

    getIpAddr
fi
