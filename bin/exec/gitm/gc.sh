#!/usr/bin/env bash
VERSION=1.1
for opt in "${UKOPT[@]}"; do
	case "${opt}" in
	"-h" | "--help")
		yldoc git-mirror
		exit 0
		;;
	"-v" | "--version")
		echo "${VERSION}"
		exit 0
		;;
	*)
		warnh "Option '${opt}' invalid. Ignored"
		;;
	esac
done

tmpf="$(mktemp -t gitm.XXXXX)"
function __gc() {
	infoh "Repository UUID=${fields[1]} gc started"
	rm -fr "${fields[1]}".gc
	cp -r "${fields[1]}" "${fields[1]}".gc
	echo -e "$(timestamp)\tGC_CPDIR\tSUCCESS\t${fields[0]}\t${fields[1]}" >>act.log
	cd "${fields[1]}".gc
	if git gc --aggressive --prune=now &>../logs/"${fields[1]}"/gc-"$(date '+%Y-%m-%d_%H-%M-%S')".log; then
		cd ..
		mv "${fields[1]}" "${fields[1]}".obs
		mv "${fields[1]}".gc "${fields[1]}"
		rm -rf "${fields[1]}".obs
		echo -e "$(timestamp)\tGC\tSUCCESS\t${fields[0]}\t${fields[1]}" >>act.log
		infoh "Repository UUID=${fields[1]} gc success"
	else
		cd ..
		rm -rf "${fields[1]}".gc
		echo -e "$(timestamp)\tGC\tFAILED\t${fields[0]}\t${fields[1]}" >>act.log
		warnh "Repository UUID=${fields[1]} gc failed. Will skip this repo"
	fi
	rm "${fields[1]}".lock
}
set -C
if ! echo -e "gc\t${$}" >gc.lock 2>/dev/null; then
	set +C
	echo -e "$(timestamp)\tGC\tOCCUPIED" >>act.log
	errh "Repository being gced by $(cat sync.lock)"
fi
cat uuidtable.d/* | while read line; do
	IFS=$'\t'
	fields=(${line})
	IFS=''
	set -C
	if ! echo -e "gc\t${$}" >"${fields[1]}".lock 2>/dev/null; then
		warnh "Repository UUID=${fields[1]} is being locked by $(cat "${fields[1]}".lock). Will skip this repo"
		echo -e "$(timestamp)\tGC\tOCCUPIED\t${fields[0]}\t${fields[1]}" >>act.log
		continue
	fi
	set +C
	__gc
done
rm -f "${tmpf}" gc.lock
