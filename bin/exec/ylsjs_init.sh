#!/usr/bin/env bash
#YLSJS_INIT v1
STDS=()
NAME="UK"
for opt in "${OPT[@]}"; do
	case "${opt}" in
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
MAX_JOB=$("${myls}" -1 *.sh | wc -l | awk '{print $1}')
MAX_JOB=$((${MAX_JOB}+1))
echo "${NAME}" > ${MAX_JOB}.q
echo "${WD}" > ${MAX_JOB}.wd
"${mycat}" /dev/stdin > ${MAX_JOB}.sh
echo ${MAX_JOB}
infoh "$("${mycat}" ${MAX_JOB}.q)"
