#GITM_GC.sh v1
tmpf="$(mktemp -t gitm.XXXXX)"
function __gc() {
	infoh "Repository UUID=${fields[1]} gc started"
	"${myrm}" -fr "${fields[1]}".gc
	"${mycp}" -r "${fields[1]}" "${fields[1]}".gc
	echo -e "$(timestamp)\tGC_CPDIR\tSUCCESS\t${fields[0]}\t${fields[1]}" >> act.log
	cd "${fields[1]}".gc
	if git gc --aggressive --prune=now &> ../logs/"${fields[1]}"/gc-"$(date '+%Y-%m-%d_%H-%M-%S')".log; then
		cd ..
		"${mymv}" "${fields[1]}" "${fields[1]}".obs
		"${mymv}" "${fields[1]}".gc "${fields[1]}"
		"${myrm}" -rf "${fields[1]}".obs
		echo -e "$(timestamp)\tGC\tSUCCESS\t${fields[0]}\t${fields[1]}" >> act.log
		infoh "Repository UUID=${fields[1]} gc success"
	else
		cd ..
		"${myrm}" -rf "${fields[1]}".gc
		echo -e "$(timestamp)\tGC\tFAILED\t${fields[0]}\t${fields[1]}" >> act.log
		warnh "Repository UUID=${fields[1]} gc failed. Will skip this repo"
	fi
	"${myrm}" "${fields[1]}".lock
}
set -C
if ! echo -e "gc\t${$}" > gc.lock 2> /dev/null; then
	set +C
	echo -e "$(timestamp)\tGC\tOCCUPIED" >> act.log
	errh "Repository being gced by $("${mycat}" sync.lock)"
fi
"${mycat}" uuidtable.d/* | while read line; do
	IFS=$'\t'
	fields=(${line})
	IFS=''
	set -C
	if ! echo -e "gc\t${$}" > "${fields[1]}".lock 2> /dev/null; then
		warnh "Repository UUID=${fields[1]} is being locked by $("${mycat}" "${fields[1]}".lock). Will skip this repo"
		echo -e "$(timestamp)\tGC\tOCCUPIED\t${fields[0]}\t${fields[1]}" >> act.log
		continue
	fi
	set +C
	__gc
done
"${myrm}" -f "${tmpf}" gc.lock
