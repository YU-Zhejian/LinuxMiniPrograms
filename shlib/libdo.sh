#!/usr/bin/env bash
# VERSION=2.7
__include libstr

if [ -z "${__LIBDO_VERSION:-}" ];then
    __LIBDO_VERSION=2.7

    __DO_ECHO() {
        [ "${LIBDO_LOG_MODE:-}" = "S" ] && builtin return || true
        [ -n "${LIBDO_LOG:-}" ] && builtin echo "${*}" >>"${LIBDO_LOG}" || builtin echo -e "${YELLOW}${*}${NOCOLOR}" >&2
    }

    __DO () {
        builtin local LIBDO_CMD
        LIBDO_CMD="${*}"
        __DO_ECHO "LIBDO IS GOING TO EXECUTE ${LIBDO_CMD}"
        __DO_ECHO "LIBDO STARTED AT $(date "+%Y-%m-%d %H:%M:%S")"
        builtin local LIBDO_PID
        builtin echo $LIBDO_CMD
        if [ -z "${LIBDO_LOG:-}" ]; then
            builtin eval "${LIBDO_CMD}" &
            LIBDO_PID=${!}
        else
            case "${LIBDO_LOG_MODE:-}" in
            "2")
                # shellcheck disable=SC2086
                builtin eval ${LIBDO_CMD} 2>>"${LIBDO_LOG}" &
                LIBDO_PID=${!}
                ;;
            "3")
                builtin eval "${LIBDO_CMD}" >>"${LIBDO_LOG}" &
                LIBDO_PID=${!}
                ;;
            "4")
                # shellcheck disable=SC2086
                builtin eval ${LIBDO_CMD} &>>"${LIBDO_LOG}" &
                LIBDO_PID=${!}
                ;;
            *)
                builtin eval "${LIBDO_CMD}" &
                LIBDO_PID=${!}
                ;;
            esac
        fi
        [ -z "${LIBDO_TOP_PID:-}" ] && __DO_ECHO "LIBDO PID ${LIBDO_PID}" || __DO_ECHO "LIBDO PID ${LIBDO_PID} with top_pid ${LIBDO_TOP_PID}"
        builtin wait ${LIBDO_PID} && LIBDO_PRIV=0 || LIBDO_PRIV=${?}
        __DO_ECHO "LIBDO STOPPED AT $(date "+%Y-%m-%d %H:%M:%S")"
        if [ ${LIBDO_PRIV} -ne 0 ]; then
            __DO_ECHO "LIBDO FAILED, GOT \$?=${LIBDO_PRIV}"
            if [ -n "${LIBDO_TOP_PID:-}" ]; then
                __DO_ECHO "LIBDO WILL KILL ${LIBDO_TOP_PID}"
                builtin kill -9 "${LIBDO_TOP_PID}"
            fi
        else
            __DO_ECHO "LIBDO EXITED SUCCESSFULLY"
        fi
        builtin return ${LIBDO_PRIV}
    }

    # Compatibility support
    # shellcheck disable=SC1081
    DO(){
        __DO "${@}"
    }

    DO_ECHO(){
        __DO_ECHO "${@}"
    }
fi
