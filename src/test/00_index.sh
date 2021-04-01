#!/usr/bin/env bash
set +e -u
DN="$(readlink -f "$(dirname "${0}")")"
cd "${DN}"
. ../../lib/libstr
infoh "Performing tests with args=${*}..."
for args in "${@}";do
	if [ "${args}" = "all" ];then
		for fn in "${DN}"/*.t.sh;do
			printf "Executing ${fn}..."
			bash "${fn}" && echo "PASS" || echo "FAIL"
		done
		exit
	elif [ -f "${DN}"/"${args}".t.sh ];then
		printf "Executing ${DN}/${args}.t.sh..."
		bash "${DN}"/"${args}".t.sh && echo "PASS" || echo "FAIL"
	else
		warnh "Target ${args} invalid. Skip"
	fi
done
