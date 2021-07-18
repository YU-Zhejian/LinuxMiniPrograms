#!/usr/bin/env bash
# VERSION=1.6
if [ -z "${__LIBMAN_VERSION:-}" ];then
    __LIBMAN_VERSION=1.6
    getuser() {
        if [ -n "${USER:-}" ]; then
            builtin printf "${USER}"
            return
        elif [ -n "${USERNAME:-}" ]; then
            builtin printf "${USERNAME}"
            return
        else
            builtin return 1
        fi
    }
    getcorenumber() {
        # shellcheck disable=SC2154
        if [[ "${myos}" == *"BSD"* ]] || [[ "${myos}" == *"Darwin"* ]]; then
            sysctl -a | grep hw.ncpu | awk '{print $2;}'
        else
            cat /proc/cpuinfo | grep '^processor\s: ' | wc -l | awk '{print $1}'
        fi
    }
    killtree() {
        builtin kill -19 ${1} || return
        for CPID in $(ps -o pid --no-headers --ppid ${1}); do
            killtree ${CPID} ${2}
        done
        builtin kill -${2} ${1} || return
    }
fi
