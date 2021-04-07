VERSION=1
tmpf="$(mktemp -t gitm.XXXXX)"
function __rm() {
	rm -fr "${fields[1]}".rm logs/"${fields[1]}"
	infoh "Repository UUID=${fields[1]} rm success"
	echo -e "$(timestamp)\tRMDIR\tSUCCESS\t${fields[0]}\t${fields[1]}" >> act.log
	echo -e "$(timestamp)\tRM\tSUCCESS\t${fields[0]}\t${fields[1]}" >> act.log
}
FORCE=false
for opt in "${@}"; do
	if isopt "${opt}"; then
		case "${opt}" in
		"-f" | "--force")
			FORCE=true
			;;
		esac
	fi
done
[ ${#STDS[@]} -gt 0 ] || errh "Need more than ONE argument"
for url in "${STDS[@]}"; do
	grep_uuidtable "${url}" "${tmpf}" || warnh "${url} yields no results"
done
if ! ${FORCE}; then read -p "Will remove above repos. Continue? [Y/n] >" ANSWER; else ANSWER="Y"; fi
if [ "${ANSWER}" = "Y" ]; then
	set -C
	if ! echo -e "rm\t${$}" > rm.lock 2> /dev/null; then
		set +C
		echo -e "$(timestamp)\tRM\tOCCUPIED" >> act.log
		errh "Repository being rmed by $(cat rm.lock)"
	fi
	set +C
	cat "${tmpf}" | while read line; do
		IFS=$'\t'
		fields=(${line})
		IFS=''
		set -C
		if ! echo -e "rm\t${$}" > "${fields[1]}".lock 2> /dev/null; then
			warnh "Repository UUID=${fields[1]} is being locked by $(cat "${fields[1]}".lock). Will skip this repo"
			echo -e "$(timestamp)\tRM\tOCCUPIED\t${fields[0]}\t${fields[1]}" >> act.log
			continue
		fi
		set +C
		infoh "Repository UUID=${fields[1]} rm started"
		mv "${fields[1]}" "${fields[1]}".rm
		echo -e "$(timestamp)\tRM_MVDIR\tSUCCESS\t${fields[0]}\t${fields[1]}" >> act.log
		if ! rmrec "${fields[1]}"; then
			rm -f "${tmpf}" rm.lock "${fields[1]}".lock
			exit 1
		fi
		rm -f "${fields[1]}".lock
		__rm
	done
fi
rm -f "${tmpf}" rm.lock
