#GITM_RM.sh v1
tmpf="$(mktemp -t gitm.XXXXX)"
function mygrep() {
	wait_time=${max_wait_time:4}
	while true;do
		if [ ${wait_time} -gt 0 ];then
			wait_time=$((${wait_time}-1))
		else
			errh "Waited for ${max_wait_time:4} times. Abort."
		fi
		if ! echo -e "rm\t${$}" > uuidtable.lock 2> /dev/null;then
			warnh "UUIDTABLE is being locked by $("${mycat}" "${fields[1]}".lock). Will wait for some seconds."
			echo -e "$(timestamp)\tRMRECORD\tOCCUPIED\t${fields[0]}\t${fields[1]}" >> act.log
			sleep $(( (RANDOM % 10) + 1 ))
		else
			break
		fi
	done
	tmpff="$(mktemp -t gitm.XXXXX)"
	"${mygrep}" -v "${1}" uuidtable > "${tmpff}"
	"${mymv}" "${tmpff}" uuidtable
	echo -e "$(timestamp)\tRMRECORD\tSUCCESS\t${fields[0]}\t${fields[1]}" >> act.log
}
function rmrepodir(){
	"${myrm}" -fr "${fields[1]}".rm logs/"${fields[1]}"
	infoh "Repository UUID=${fields[1]} rm success."
	echo -e "$(timestamp)\tRMDIR\tSUCCESS\t${fields[0]}\t${fields[1]}" >> act.log
	echo -e "$(timestamp)\tRM\tSUCCESS\t${fields[0]}\t${fields[1]}" >> act.log
}
set -C
if ! echo -e "rm\t${$}" > rm.lock 2> /dev/null;then
	set +C
	echo -e "$(timestamp)\tRM\tOCCUPIED" >> act.log
	errh "Repository being rmed by $("${mycat}" sync.lock)."
fi
set +C
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
[ ${#STDS[@]} -gt 0 ] || errh "Need more than ONE argument."
for url in "${STDS[@]}"; do
	"${mygrep}" "${url}" uuidtable | tee "${tmpf}" || warnh "${url} yeilds no results"
done
! ${FORCE} && read -p "Will remove above repos. Continue? [Y/n] >" ANSWER || ANSWER="Y"
if [ "${ANSWER}" = "Y" ]; then
	"${mycat}" "${tmpf}" | while read line; do
		IFS=$'\t'
		fields=(${line})
		IFS=''
		set -C
		if ! echo -e "rm\t${$}" > "${fields[1]}".lock 2> /dev/null;then
			warnh "Repository UUID=${fields[1]} is being locked by $("${mycat}" "${fields[1]}".lock). Will skip this repo."
			echo -e "$(timestamp)\tRM\tOCCUPIED\t${fields[0]}\t${fields[1]}" >> act.log
			continue
		fi
		set +C
		"${mymv}" "${fields[1]}" "${fields[1]}".rm
		echo -e "$(timestamp)\tRM_MVDIR\tSUCCESS\t${fields[0]}\t${fields[1]}" >> act.log
		mygrep "${fields[1]}"
		"${myrm}" -f "${fields[1]}".lock
		rmrepodir &
	done
	wait
fi
"${myrm}" -f "${tmpf}" rm.lock
