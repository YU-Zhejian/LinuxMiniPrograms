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

if [ ${#STDS[@]} -gt 0 ]; then
	for url in "${STDS[@]}"; do
		grep_uuidtable "${url}" "${tmpf}" &>>/dev/null || warnh "${url} yields no results"
	done
else
	cat uuidtable.d/* | tee "${tmpf}"
fi
cat "${tmpf}" | while read line; do
	IFS=$'\t'
	fields=(${line})
	IFS=''
	infoh "${fields[0]}"
	[ ! -f "${fields[1]}".lock ] || warnh "Repo locked by $(cat "${fields[1]}".lock)"
	cd "${fields[1]}"
	if git branch --verbose 2>&1 | tee ../logs/"${fields[1]}"/lsbranch-"$(date '+%Y-%m-%d_%H-%M-%S')".log; then
		cd ..
		echo -e "$(timestamp)\tLSBRANCH\tSUCCESS\t${fields[0]}\t${fields[1]}" >>act.log
	else
		cd ..
		echo -e "$(timestamp)\tLSBRANCH\tFAILED\t${fields[0]}\t${fields[1]}" >>act.log
		warnh "Repository UUID=${fields[1]} lsbranch failed. Will skip this repo"
	fi
done
rm -f "${tmpf}"
