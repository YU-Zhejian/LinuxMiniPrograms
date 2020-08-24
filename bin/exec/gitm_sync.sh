#GITM_SYNC.sh v1
tmpf="$(mktemp -t gitm.XXXXX)"
function sync() {
	infoh "Repository UUID=${fields[1]} sync started"
	"${mycp}" -r "${fields[1]}" "${fields[1]}".sync
	echo -e "$(timestamp)\tSYNC_CPDIR\tSUCCESS\t${fields[0]}\t${fields[1]}" >> act.log
	cd "${fields[1]}".sync
	if git remote --verbose update --prune  &> ../logs/"${fields[1]}"/sync-"$(date '+%Y-%m-%d_%H-%M-%S')".log; then
		cd ..
		"${mymv}" "${fields[1]}" "${fields[1]}".obs
		"${mymv}" "${fields[1]}".sync "${fields[1]}"
		"${myrm}" -rf "${fields[1]}".obs
		echo -e "$(timestamp)\tSYNC\tSUCCESS\t${fields[0]}\t${fields[1]}" >> act.log
		infoh "Repository UUID=${fields[1]} sync success"
	else
		cd ..
		"${myrm}" -rf "${fields[1]}".sync
		echo -e "$(timestamp)\tSYNC\tFAILED\t${fields[0]}\t${fields[1]}" >> act.log
		warnh "Repository UUID=${fields[1]} sync failed. Will skip this repo"
	fi
	"${myrm}" "${fields[1]}".lock
}
set -C
if ! echo -e "sync\t${$}" > sync.lock 2> /dev/null; then
	set +C
	echo -e "$(timestamp)\tSYNC\tOCCUPIED" >> act.log
	errh "Repository being synced by $("${mycat}" sync.lock)"
fi
set +C
"${mycat}" uuidtable.d/* | while read line; do
	IFS=$'\t'
	fields=(${line})
	IFS=''
	set -C
	if ! echo -e "sync\t${$}" > "${fields[1]}".lock 2> /dev/null; then
		warnh "Repository UUID=${fields[1]} is being locked by $("${mycat}" "${fields[1]}".lock). Will skip this repo"
		echo -e "$(timestamp)\tSYNC\tOCCUPIED\t${fields[0]}\t${fields[1]}" >> act.log
		continue
	fi
	set +C
	sync
done
"${myrm}" -f "${tmpf}" sync.lock
