#!/usr/bin/env bash
VERSION=1.2
NAME="UK"
for opt in "${UKOPT[@]}"; do
	case "${opt}" in
	"-h" | "--help")
		yldoc ylsjs
		exit 0
		;;
	"-v" | "--version")
		echo "${VERSION}"
		exit 0
		;;
	-n\:*)
		NAME=${opt:3}
		;;
	--name\:*)
		NAME=${opt:7}
		;;
	*)
		warnh "Option '${opt}' invalid. Ignored"
		;;
	esac
done

MAX_JOB=$(ls -1 *.sh | wc -l | awk '{print $1}')
MAX_JOB=$((${MAX_JOB} + 1))
echo "${NAME}" >${MAX_JOB}.q
echo "${WD}" >${MAX_JOB}.wd
cat /dev/stdin >${MAX_JOB}.sh
echo ${MAX_JOB}
infoh "$(cat ${MAX_JOB}.q)"
