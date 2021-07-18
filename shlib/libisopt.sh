#!/usr/bin/env bash
if [ -z "${__LIBISOPT_VERSION:-}" ];then
    __LIBISOPT_VERSION=1.7
    isopt() {
        case "${1:-}" in
        -? | --* | -?\:*)
            builtin return 0
            ;;
        *)
            builtin return 1
            ;;
        esac
    }
fi
