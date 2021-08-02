#!/usr/bin/env bash

if [ -z "${__LIBNET_VERSION:-}" ]; then
    __LIBNET_VERSION=1.5
    if [ -z "${IP_ADDR:-}" ];then
        IP_ADDR=()
    fi

    __include libstr
    get_ip_addr() {
        tmp="$(mktemp "ipaddr.XXXXX")"
        if which ip &> /dev/null; then
            ip addr | grep inet | grep -v inet6 >"${tmp}"
        elif which ifconfig &> /dev/null; then
            ifconfig | grep inet | grep -v inet6 >"${tmp}"
        else
            errh "Need command 'ip' or 'ifconfig'."
        fi
        while builtin read line; do
            IP_ADDR=("${IP_ADDR[@]}" "$(trimstr "${line}" | cut -d ' ' -f 2)")
            # infoh "${IP_ADDR[@]}"
        done <"${tmp}"
        rm "${tmp}"
    }

    get_ip_addr
fi
