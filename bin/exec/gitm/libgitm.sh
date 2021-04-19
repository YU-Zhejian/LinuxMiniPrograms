#!/usr/bin/env bash
# VERSION=1.2
function timestamp() {
	date '+%Y-%m-%d %H:%M:%S'
}
function grep_uuidtable() {
	for fn in uuidtable.d/*; do
		(grep "^${1}\t" "${fn}" >>"${2}" || true) &
		(grep "\t${1}$" "${fn}" >>"${2}" || true) &
	done
	wait
	[ $(wc -l "${2}" | awk '{print $1}') -ne 0 ] || return 1
	cat "${2}"
}
function rmrec() {
	local wait_time=4
	while true; do
		if [ ${wait_time} -gt 0 ]; then
			wait_time=$((${wait_time} - 1))
		else
			warnh "Waited for 4 times. Abort"
			return 1
		fi
		if ! echo -e "rm\t${$}" >uuidtable.lock 2>/dev/null; then
			warnh "UUIDTABLE is being locked by $(cat "${fields[1]}".lock). Will wait for some seconds"
			echo -e "$(timestamp)\tRMRECORD\tOCCUPIED\t${fields[0]}\t${fields[1]}" >>act.log
			sleep $(((RANDOM % 10) + 1))
		else
			break
		fi
	done
	tmpff="$(mktemp -t gitm.XXXXX)"
	for fn in uuidtable.d/*; do
		grep -v "${1}" "${fn}" >"${tmpff}" || true
		if [ $(wc -l "${fn}" | awk '{print $1}') -ne $(wc -l "${tmpff}" | awk '{print $1}') ]; then
			mv "${tmpff}" "${fn}"
			break
		fi
	done
	rm -f uuidtable.lock "${tmpff}"
	echo -e "$(timestamp)\tRMRECORD\tSUCCESS\t${fields[0]}\t${fields[1]}" >>act.log
}
