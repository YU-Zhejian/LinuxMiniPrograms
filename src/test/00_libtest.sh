#!/usr/bin/env bash
# shellcheck disable=SC2034
VERSION=1.3

# LibDO 2.1 rewritten with environment variable support
DO_ECHO() {
    echo "${@}" >>"${LIBDO_LOG}"
}
DO() {
    local LIBDO_CMD="${*}"
    tmpf1="$(mktemp "libdo.XXXXXX")"
    tmpf2="$(mktemp "libdo.XXXXXX")"
    DO_ECHO "LIBDO IS GOING TO EXECUTE ${LIBDO_CMD}"
    export >>"${tmpf1}"
    DO_ECHO "LIBDO STARTED AT $(date "+%Y-%m-%d %H:%M:%S")"
    local LIBDO_PID
    # shellcheck disable=SC2086
    eval ${LIBDO_CMD} &>>"${LIBDO_LOG}" &
    LIBDO_PID=${!}
    DO_ECHO "LIBDO PID ${LIBDO_PID} with top_pid ${LIBDO_TOP_PID}"
    wait ${LIBDO_PID} && LIBDO_PRIV=0 || LIBDO_PRIV=${?}
    DO_ECHO "LIBDO STOPPED AT $(date "+%Y-%m-%d %H:%M:%S")"
    DO_ECHO "LIBDO ENVIRONS:"
    export >>"${tmpf2}"
    DO_ECHO "$(diff -u "${tmpf2}" "${tmpf1}")"
    rm "${tmpf2}" "${tmpf1}"
    if [ ${LIBDO_PRIV} -ne 0 ]; then
        DO_ECHO "LIBDO FAILED, GOT \$?=${LIBDO_PRIV}"
        DO_ECHO "LIBDO WILL KILL ${LIBDO_TOP_PID}"
        kill -9 "${LIBDO_TOP_PID}"
    else
        DO_ECHO "LIBDO EXITED SUCCESSFULLY"
    fi
    return ${LIBDO_PRIV}
}

LIBDO_TOP_PID=${$}
TDN="${DN}/${PROGNAME}_$(date +%Y-%m-%d_%H-%M-%S).t"
mkdir -p "${TDN}"
cd "${TDN}" || exit 1
LIBDO_LOG="${PROGNAME}.log"
