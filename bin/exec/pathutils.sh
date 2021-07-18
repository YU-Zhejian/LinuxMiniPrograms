#!/usr/bin/env bash
# shellcheck disable=SC2034
VERSION=1.5

__addpref() {
    builtin echo "/${1}"
    builtin echo "/usr/${1}"
    builtin echo "/usr/local/${1}"
    builtin echo "${HOME}/${1}"
    builtin echo "${HOME}/usr/${1}"
    builtin echo "${HOME}/usr/local/${1}"
}
