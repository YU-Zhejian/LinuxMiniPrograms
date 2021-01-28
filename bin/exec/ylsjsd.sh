#!/usr/bin/env bash
#YLSJSD.sh v1
set -ue
DN="$(readlink -f "$(dirname "${0}")")"
. "${DN}"/../../etc/path.sh
. "${DN}"/../../lib/libstr
. "${DN}"/../../lib/libisopt
. "${DN}"/../../lib/libman
declare -i MAX_JOB
MAX_JOB=$(getcorenumber)
echo ${$} >>ylsjsd.lock
infoh "ylsjsd started at $(date)"

function __exit() {
	infoh "ylsjsd terminated at $(date)"
	"${myrm}" ylsjsd.lock
	exit
}
trap "__exit" SIGINT SIGTERM

while true; do
	sleep 1
	# Rmove done jobs
	"${myls}" -1 | "${mygrep}" '\.i' |  "${mysed}" 's;.i$;;' | while read ps_name; do
		PID=$("${mycat}" ${ps_name}.i | tail -n 1)
		! "${myps}" -p ${PID} &>>/dev/null && "${mymv}" "${ps_name}.i" "${ps_name}.f"
	done
	# Check the queue
	while [ $("${myls}" -1 | "${mygrep}" '\.i' | wc -l | awk '{ printf $1 }') -lt ${MAX_JOB} ]; do
		lastq=$("${myls}" -1 | "${mygrep}" '\.q$' | "${mysort}" -n | head -n 1 | "${mysed}" 's;.q$;;')
		if [ "${lastq}" = "" ]; then break; fi
		cd "$("${mycat}" "${lastq}.wd")"
		bash "${DN}"/../../var/ylsjs.d/${lastq}.sh &
		cd "${DN}"/../../var/ylsjs.d
		echo "${!}" >>"${lastq}".q
		"${mymv}" "${lastq}.q" "${lastq}.i"
	done
done
