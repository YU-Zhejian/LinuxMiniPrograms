#!/usr/bin/env bash
#YLSJS_INIT v1
STDS=()
MAX_JOB=$("${myls}" -1 *.sh | wc -l | awk '{print $1}')
MAX_JOB=$((${MAX_JOB}+1))
echo "UK" > ${MAX_JOB}.q
echo "${WD}" > ${MAX_JOB}.wd
"${mycat}" /dev/stdin > ${MAX_JOB}.sh
echo ${MAX_JOB}
infoh "$("${mycat}" ${MAX_JOB}.q)"
