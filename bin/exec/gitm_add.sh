# GITM_ADD.sh v1
[ ${#STDS[@]} -gt 0 ] || errh "Need more than ONE argument."
[ "${mypython}" != "ylukh" ] || errh "Python not found"

for url in "${STDS[@]}"; do
	url=$(echo ${url} | "${mysed}" 's;file://;;')
	"${mypython}" "${DN}"/exec/valid_url.py "${url}" || errh "Bad URL ${url}".
	tmpf="$(mktemp -t gitm.XXXXX)"
	! grep_uuidtable "${url}" "${tmpf}" &>> /dev/null || errh "${url} exists"
	while true; do
		uuid=$(uuidgen -t)
		grep_uuidtable "${uuid}" "${tmpf}" &>> /dev/null || break
	done
	infoh ${url}' -> '${uuid}
	mkdir "logs/${uuid}/"
	if git clone --mirror --no-hardlinks --verbose --progress "${url}" "${uuid}" 2>&1 | tee "logs/${uuid}/add-$(date '+%Y-%m-%d_%H-%M-%S').log"; then
		for fn in uuidtable.d/*; do
			ADDED=false
			if [ $(wc -l "${fn}" | awk '{print $1}') -le 1000 ]; then
				ADDED=true
				echo -e "${url}\t${uuid}" >> "${fn}"
				break
			fi
		done
		if ! ${ADDED}; then
			echo -e "${url}\t${uuid}" >> $(date '+%Y-%m-%d_%H-%M-%S')
		fi
		echo -e "$(timestamp)\tADD\tSUCCESS\t${url}\t${uuid}" >> act.log
	else
		warnh "${url} corrupted. Will be skipped."
		"${myrm}" -rf "${uuid}" "logs/${uuid}/"
		echo -e "$(timestamp)\tADD\tFAILED\t${url}\t${uuid}" >> act.log
	fi
done
"${myrm}" -f "${tmpf}"
