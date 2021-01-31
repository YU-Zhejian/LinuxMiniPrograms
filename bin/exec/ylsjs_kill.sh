#!/usr/bin/env bash
#YLSJS_KILL v1
STDS=()
n=15
for opt in "${@}"; do
	if isopt "${opt}"; then
		case "${opt}" in
		-n\:*)
			n=${opt:3}
			;;
		esac
	else
		STDS=("${STDS[@]}" "${opt}")
	fi
done

unset STDS[0]

function __kill() {
	if [ -f "${1}".q ]; then
			mv "${1}".q "${ps_name}".f
			return
	elif [ -f "${1}".f ]; then
			warnh "Process ${1} finished"
			return
		elif ! [ -f ${1}.i ]; then
			warnh "Process ${1} not found"
			return
		fi
		PID=$(cat ${1}.i | tail -n 1)
		kill -${n} -- -${PID} || true
		sleep 1
		if ps -p ${PID} &>>/dev/null ;then
			warnh "Failed to kill ${1} with PID=${PID}. Retry with -n:9 option"
		else
			infoh "${1} killed"
		fi
}

if [ ${#STDS[@]} -eq 0 ]; then
	errh "Which process to kill?"
else
	for ps_name in "${STDS[@]}"; do
		__kill ${ps_name} &
	done
fi
