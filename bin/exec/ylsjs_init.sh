#!/usr/bin/env bash
#YLSJS_INIT v1
STDS=()
MAX_JOB=$("${myls}" -1 | "${mygrep}" -v 'sh' | "${mygrep}" -v 'lock' | "${mysed}" 's;.[qf]^;;' | wc -l | awk '{print $1}')
MAX_JOB=$((${MAX_JOB}+1))
echo "UK" > ${MAX_JOB}.q
"${mycat}" /dev/stdin > ${MAX_JOB}.sh
