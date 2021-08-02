#!/usr/bin/env bash
if [ -z "${__LIBMAN_VERSION:-}" ]; then
    __LIBMAN_VERSION=1.7
    get_user() {
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

    get_core_number() {
        # shellcheck disable=SC2154
        if [[ "${myos}" == *"BSD"* ]] || [[ "${myos}" == *"Darwin"* ]]; then
            sysctl -a | grep hw.ncpu | awk '{print $2;}'
        else
            cat /proc/cpuinfo | grep '^processor\s: ' | wc -l | awk '{print $1}'
        fi
    }

    kill_tree() {
        builtin kill -19 ${1} || return
        for CPID in $(ps -o pid --no-headers --ppid ${1}); do
            kill_tree ${CPID} ${2}
        done
        builtin kill -${2} ${1} || return
    }

    has_python_package(){
        if [ ${#} -eq 1 ];then
            builtin echo "import ${1}" | python3 &>/dev/null || return ${?}
        else
            builtin echo "import ${1}" | "${2}" &>/dev/null || return ${?}
        fi
    }
fi
