#!/usr/bin/env bash
#YLSJS_KILL v1
cd "${DN}"/../var/ylsjs.d
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
	for ps_name in "${STDS[@]}";do
		if ! [ -f ${ps_name} ];then
			warnh "Process ${ps_name} not found"
			continue
		fi
		kill -${n} ${ps_name} || true
		sleep 1
		if ps -p ${ps_name} &>> /dev/null;then
			errh "Failed to kill ${ps_name}. Retry with -n:9 option"
		else
			"${myrm}" "${ps_name}" "${ps_name}.sh"
		fi
	done
fi
