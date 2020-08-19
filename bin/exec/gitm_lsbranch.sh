#GITM_LSBRANCH.sh v1
tmpf="$(mktemp -t gitm.XXXXX)"

if [ ${#STDS[@]} -gt 0 ];then
	for url in "${STDS[@]}"; do
		"${mygrep}" "${url}" uuidtable | tee "${tmpf}" || warnh "${url} yeilds no results"
	done
else
	"${mycat}" uuidtable | tee "${tmpf}"
fi
infoh "Will lsbranch above repos."
"${mycat}" "${tmpf}" | while read line; do
	IFS=$'\t'
	fields=(${line})
	IFS=''
	infoh "${fields[0]}"
	cd "${fields[1]}"
	if git branch --verbose 2>&1 | tee ../logs/"${fields[1]}"/lsbranch-"$(date '+%Y-%m-%d_%H-%M-%S')".log; then
		cd ..
		echo -e "$(timestamp)\tLSBRANCH\tSUCCESS\t${fields[0]}\t${fields[1]}" >> act.log
	else
		cd ..
		echo -e "$(timestamp)\tLSBRANCH\tFAILED\t${fields[0]}\t${fields[1]}" >> act.log
		warnh "Repository UUID=${fields[1]} lsbranch failed. Will skip this repo."
	fi
done
"${myrm}" -f "${tmpf}"
