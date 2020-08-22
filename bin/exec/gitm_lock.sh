#GITM_LOCK.sh v1

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
case "${STDS[1]}" in
"ls")
	if ls *.lock &>> /dev/null; then
		for fn in *.lock; do
			printf ${fn}"\t"
			"${mycat}" ${fn}
		done
		echo -e "$(timestamp)\tLOCKLS\tSUCCESS" >> act.log
		infoh "Repository lock ls success."
	else
		infoh "No lock presented."
		echo -e "$(timestamp)\tLOCKLS\tNOLOCK" >> act.log
	fi
	;;
"rm")
	unset STDS[1]
	tmpf="$(mktemp -t gitm.XXXXX)"
	tmpff="$(mktemp -t gitm.XXXXX)"
	if [ ${#STDS[@]} -gt 0 ]; then
		for url in "${STDS[@]}"; do
			"${mygrep}" "${url}" uuidtable > "${tmpf}" || warnh "${url} yeilds no results"
		done
	else
		${mycat} uuidtable > "${tmpf}"
	fi
	while read line; do
		IFS=$'\t'
		fields=(${line})
		IFS=''
		[ -f "${fields[1]}".lock ] && echo ${line} | tee -a "${tmpff}"
	done < "${tmpf}"
	if ! ${FORCE} ;then read -p "Will remove locks of above repos. Continue? [Y/n] >" ANSWER ; else ANSWER="Y"; fi
	if [ "${ANSWER}" = "Y" ]; then
		"${mycat}" "${tmpff}" | while read line; do
			"${myrm}" -f "${fields[1]}".lock
			echo -e "$(timestamp)\tRMLOCK\tSUCCESS\t${fields[0]}\t${fields[1]}" >> act.log
			infoh "Repository UUID=${fields[1]} rmlock success."
		done
	fi
	"${myrm}" -f "${tmpf}" "${tmpff}"
	;;
"rm_sarg")
	"${myrm}" -f sync.lock rm.lock archive.lock gc.lock
	;;
"add")
	unset STDS[1]
	[ ${#STDS[@]} -gt 0 ] || errh "Need more than ONE argument."
	tmpf="$(mktemp -t gitm.XXXXX)"
	for url in "${STDS[@]}"; do
		"${mygrep}" "${url}" uuidtable |tee -a "${tmpf}" || warnh "${url} yeilds no results"
	done
	if ! ${FORCE} ;then read -p "Will add locks to above repos. Continue? [Y/n] >" ANSWER ; else ANSWER="Y"; fi
	if [ "${ANSWER}" = "Y" ]; then
		"${mycat}" "${tmpf}" | while read line; do
			IFS=$'\t'
			fields=(${line})
			IFS=''
			echo -e "lock\t${$}" > "${fields[1]}".lock
			echo -e "$(timestamp)\tADDLOCK\tSUCCESS\t${fields[0]}\t${fields[1]}" >> act.log
			infoh "Repository UUID=${fields[1]} addlock success."
		done
	fi
	"${myrm}" -f "${tmpf}"
	;;
*)
	errh "Invalid sub-sub cmmand '${STDS[1]}'"
	;;
esac
