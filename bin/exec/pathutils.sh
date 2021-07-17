#!/usr/bin/env bash
VERSION=1.3

__addpref() {
    echo "/${1}"
    echo "/usr/${1}"
    echo "/usr/local/${1}"
    echo "${HOME}/${1}"
    echo "${HOME}/usr/${1}"
    echo "${HOME}/usr/local/${1}"
}
