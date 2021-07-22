#!/usr/bin/env bash

if [ -z "${__LIBSTR_VERSION:-}" ]; then
    __LIBSTR_VERSION=1.6
    # Check for color support
    ANSI_RED=""
    ANSI_GREEN=""
    ANSI_YELLOW=""
    ANSI_BLUE=""
    ANSI_PURPLE=""
    ANSI_CRAYON=""
    ANSI_CLEAR=""
    HAVE_COLOR=0
    COLORS="$(tput colors 2>/dev/null)" || true
    test -t && HAVE_COLOR=1
    # shellcheck disable=SC2086
    [ ${COLORS:-0} -gt 2 ] && HAVE_COLOR=1
    [[ "${TERM:-}" =~ "256" ]] && HAVE_COLOR=1
    if [ ${HAVE_COLOR} -eq 1 ]; then
        ANSI_RED="\033[31m"
        # shellcheck disable=SC2034
        ANSI_GREEN="\033[32m"
        ANSI_YELLOW="\033[33m"
        # shellcheck disable=SC2034
        ANSI_BLUE="\033[34m"
        # shellcheck disable=SC2034
        ANSI_PURPLE="\033[35m"
        # shellcheck disable=SC2034
        ANSI_CRAYON="\033[36m"
        ANSI_CLEAR="\033[0m"
    fi

    trimstr() {
        : "${1#"${1%%[![:space:]]*}"}" # Trim trailing space
        : "${_%"${_##*[![:space:]]}"}" # Trim leading space
        builtin printf '%s\n' "${_}"
    }

    errh() {
        builtin echo -e "${ANSI_RED}ERROR: ${*}${ANSI_CLEAR}" >&2
        builtin exit 1
    }

    warnh() {
        builtin echo -e "${ANSI_RED}WARNING: ${*}${ANSI_CLEAR}" >&2
    }

    infoh() {
        builtin echo -e "${ANSI_YELLOW}INFO: ${*}${ANSI_CLEAR}" >&2
    }
fi
