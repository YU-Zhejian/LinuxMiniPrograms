#!/usr/bin/env bash
# shellcheck disable=SC2034
VERSION=1.5
set -ue
declare -i YLSJSD_MAX_JOB
DN="$(readlink -f "$(dirname "${0}")")"
. "${DN}"/../../etc/path.conf
. "${DN}"/../../lib/libstr
. "${DN}"/../../lib/libisopt
. "${DN}"/../../lib/libman

if [ -z "${YLSJSD_MAX_JOB:-}" ]; then
    YLSJSD_MAX_JOB=$(getcorenumber)
fi
if [ -z "${YLSJSD_HOME:-}" ]; then
    YLSJSD_HOME="${DN}"/../../var/ylsjs.d
fi
echo ${$} >>ylsjsd.lock
infoh "ylsjsd started at $(date)"

__exit() {
    infoh "ylsjsd terminated at $(date)"
    rm -f ylsjsd.lock 2>/dev/null
    exit
}
trap "__exit" SIGINT SIGTERM

while true; do
    sleep 1
    # Rmove done jobs
    # shellcheck disable=SC2010
    ls -1 2>/dev/null | grep '\.i' | sed 's;.i$;;' | while read ps_name; do
        PID=$(cat ${ps_name}.i | tail -n 1)
        if ! ps -p ${PID} &>>/dev/null; then
            mv "${ps_name}.i" "${ps_name}.f"
            date +%s >${ps_name}.end
        fi
    done
    # Check the queue
    # shellcheck disable=SC2046
    # shellcheck disable=SC2010
    while [ $(ls -1 2>/dev/null | grep '\.i' | wc -l | awk '{ printf $1 }') -lt ${YLSJSD_MAX_JOB} ]; do
        # shellcheck disable=SC2010
        lastq=$(ls -1 2>/dev/null | grep '\.q$' | sort -n | head -n 1 | sed 's;.q$;;')
        if [ "${lastq}" = "" ]; then break; fi
        date +%s >${lastq}.start
        declare >"${lastq}".env
        cd "$(cat "${lastq}.wd")"
        bash "${YLSJSD_HOME}"/${lastq}.sh 1>"${YLSJSD_HOME}"/${lastq}.stdout 2>"${YLSJSD_HOME}"/${lastq}.stderr &
        cd "${YLSJSD_HOME}"
        echo "${!}" >>"${lastq}".q
        mv "${lastq}.q" "${lastq}.i"
    done
done
