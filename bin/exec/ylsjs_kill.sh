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

if [ ${#STDS[@]} -eq 0 ]; then
	errh "Which process to kill?"
else
	for ps_name in "${STDS[@]}"; do
		if [ -f "${ps_name}".q ]; then
			"${mymv}" "${ps_name}".q "${ps_name}".f
			continue
		elif [ -f "${ps_name}".f ]; then
			warnh "Process ${ps_name} finished"
			continue
		elif ! [ -f ${ps_name} ]; then
			warnh "Process ${ps_name} not found"
			continue
		fi
		PID=$("${mycat}" ${ps_name} | tail -n 1)
		kill -${n} ${PID} || true
		sleep 1
		ps -p ${PID} &>>/dev/null && warnh "Failed to kill ${ps_name} with PID=${PID}. Retry with -n:9 option"
	done
fi
