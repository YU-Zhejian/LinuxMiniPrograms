VERSION=1.0
tmpf="$(mktemp -t gitm.XXXXX)"
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
if ! ${FORCE}; then read -p "Will remove records of above repos. Continue? [Y/n] >" ANSWER; else ANSWER="Y"; fi
if [ "${ANSWER}" = "Y" ]; then
	cat "${tmpf}" | while read line; do
		IFS=$'\t'
		fields=(${line})
		IFS=''
		if [ -d "${fields[1]}" ]; then
			warnh "Directory of this repo still exists"
			continue
		fi
		rmrec "${fields[1]}"
	done
fi
rm -f "${tmpf}"
