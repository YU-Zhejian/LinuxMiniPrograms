#!/usr/bin/env bash
function grep_uuidtable() {
	for fn in uuidtable.d/*;do
		("${mygrep}" "${1}" "${fn}" >> "${2}" || true) &
	done
	wait
	[ $(wc -l "${2}" | awk '{print $1}') -ne 0 ] || return 1
	"${mycat}" "${2}"
}
