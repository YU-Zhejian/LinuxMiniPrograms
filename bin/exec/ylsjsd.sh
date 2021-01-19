#!/usr/bin/env bash
#YLSJSD.sh v1
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
	"${myls}" -1 | "${mygrep}" -v '\.' | while read ps_name; do
		PID=$("${mycat}" ${ps_name} | tail -n 1)
		! ps -p ${PID} &>>/dev/null && "${mymv}" "${ps_name}" "${ps_name}.f"
	done
	# Check the queue
	while [ $("${myls}" -1 | "${mygrep}" -v '\.' | wc -l | awk '{ printf $1 }') -lt ${MAX_JOB} ]; do
		lastq=$("${myls}" -1 | "${mygrep}" '\.q$' | "${mysort}" -n | head -n 1 | "${mysed}" 's;.q$;;')
		if [ "${lastq}" = "" ]; then break; fi
		bash ${lastq}.sh &
		echo "${!}" >>"${lastq}".q
		"${mymv}" "${lastq}".q "${lastq}"
	done
done
