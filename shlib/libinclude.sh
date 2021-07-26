#!/usr/bin/env bash

if [ -z "${__LIBINCLUDE_VERSION:-}" ]; then
    __LIBINCLUDE_VERSION=1.1

    # This function is identical as it is in `libpath.sh`
    __addpref() {
        builtin printf "/${1}:/usr/${1}:/usr/local/${1}:${HOME}/${1}:${HOME}/usr/${1}:${HOME}/usr/local/${1}"
    }

    __core_include() {
        builtin mapfile -t eachpath < <(builtin echo ${SH_INCLUDE_PATH:-} | tr ':' '\n')
        for item in "${eachpath[@]}"; do
            for ext in '' '.sh' '.bash' '.dash' '.zsh'; do
                if [ -f "${item}/${1}${ext}" ]; then
                    builtin source "${item}/${1}${ext}"
                    builtin return 0
                fi
            done
        done
        builtin return 1
    }

    __include() {
        if [ -z "${SH_INCLUDE_PATH:-}" ]; then
            SH_INCLUDE_PATH="${PWD}:$(__addpref shlib)"
            export SH_INCLUDE_PATH
        fi
        if ! __core_include "${@}"; then
            builtin echo "ERROR: ${1} not found in SH_INCLUDE_PATH='${SH_INCLUDE_PATH:-}'"
            exit 1
        fi
    }
fi
