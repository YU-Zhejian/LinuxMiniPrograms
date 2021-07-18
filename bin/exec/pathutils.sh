#!/usr/bin/env bash
# shellcheck disable=SC2034
VERSION=1.4

__addpref() {
    echo "/${1}"
    echo "/usr/${1}"
    echo "/usr/local/${1}"
    echo "${HOME}/${1}"
    echo "${HOME}/usr/${1}"
    echo "${HOME}/usr/local/${1}"
}
