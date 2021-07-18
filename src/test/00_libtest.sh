#!/usr/bin/env bash
# shellcheck disable=SC2034
VERSION=1.6

# LibDO 2.1 rewritten with environment variable support
__DO_ECHO() {
    builtin echo "${@}" >>"${LIBDO_LOG}"
}
__DO () {
    builtin local LIBDO_CMD
    LIBDO_CMD="${*}"
    tmpf1="$(mktemp "libdo.XXXXXX")"
    tmpf2="$(mktemp "libdo.XXXXXX")"
    __DO_ECHO "LIBDO IS GOING TO EXECUTE ${LIBDO_CMD}"
    builtin export >>"${tmpf1}"
    __DO_ECHO "LIBDO STARTED AT $(date "+%Y-%m-%d %H:%M:%S")"
    builtin local LIBDO_PID
    # shellcheck disable=SC2086
    builtin eval ${LIBDO_CMD} &>>"${LIBDO_LOG}" &
    LIBDO_PID=${!}
    __DO_ECHO "LIBDO PID ${LIBDO_PID} with top_pid ${LIBDO_TOP_PID}"
    builtin wait ${LIBDO_PID} && LIBDO_PRIV=0 || LIBDO_PRIV=${?}
    __DO_ECHO "LIBDO STOPPED AT $(date "+%Y-%m-%d %H:%M:%S")"
    __DO_ECHO "LIBDO ENVIRONS:"
    builtin export >>"${tmpf2}"
    __DO_ECHO "$(diff -u "${tmpf2}" "${tmpf1}")"
    rm "${tmpf2}" "${tmpf1}"
    if [ ${LIBDO_PRIV} -ne 0 ]; then
        __DO_ECHO "LIBDO FAILED, GOT \$?=${LIBDO_PRIV}"
        __DO_ECHO "LIBDO WILL KILL ${LIBDO_TOP_PID}"
        builtin kill -9 "${LIBDO_TOP_PID}"
    else
        __DO_ECHO "LIBDO EXITED SUCCESSFULLY"
    fi
    builtin return ${LIBDO_PRIV}
}

LIBDO_TOP_PID=${$}
TDN="${DN}/${PROGNAME}_$(date +%Y-%m-%d_%H-%M-%S).t"
mkdir -p "${TDN}"
builtin cd "${TDN}" || builtin exit 1
LIBDO_LOG="${PROGNAME}.log"
