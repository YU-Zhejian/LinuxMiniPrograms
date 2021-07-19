#!/usr/bin/env bash

if [ -z "${__LIBSTR_VERSION:-}" ]; then
    __LIBSTR_VERSION=1.6
    # Check for color support
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    PURPLE=""
    CRAYON=""
    NOCOLOR=""
    HAVE_COLOR=0
    COLORS="$(tput colors 2>/dev/null)" || true
    # shellcheck disable=SC2086
    [ ${COLORS} -gt 2 ] && HAVE_COLOR=1
    [[ "${TERM:-}" =~ "256" ]] && HAVE_COLOR=1
    if [ ${HAVE_COLOR} -eq 1 ]; then
        RED="\033[31m"
        # shellcheck disable=SC2034
        GREEN="\033[32m"
        YELLOW="\033[33m"
        # shellcheck disable=SC2034
        BLUE="\033[34m"
        # shellcheck disable=SC2034
        PURPLE="\033[35m"
        # shellcheck disable=SC2034
        CRAYON="\033[36m"
        NOCOLOR="\033[0m"
    fi

    trimstr() {
        : "${1#"${1%%[![:space:]]*}"}" # Trim trailing space
        : "${_%"${_##*[![:space:]]}"}" # Trim leading space
        builtin printf '%s\n' "${_}"
    }

    errh() {
        builtin echo -e "${RED}ERROR: ${*}${NOCOLOR}" >&2
        builtin exit 1
    }

    warnh() {
        builtin echo -e "${RED}WARNING: ${*}${NOCOLOR}" >&2
    }

    infoh() {
        builtin echo -e "${YELLOW}INFO: ${*}${NOCOLOR}" >&2
    }
fi
