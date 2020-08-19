# GITM_ADD.sh v1
[ ${#STDS[@]} -gt 0 ] || errh "Need more than ONE argument."
[ "${mypython}" != "ylukh" ] || errh "Python not found"

for url in "${STDS[@]}";do
	url=$(echo ${url}|"${mysed}" 's;file://;;')
	"${mypython}" "${DN}"/exec/valid_url.py "${url}" || errh "Bad URL ${url}".
	! "${mygrep}" "${url}" "${git_mirror_dir}/uuidtable" || errh "${url} exists"
	while true; do
		uuid=$(uuidgen)
		infoh ${url}' -> '${uuid}
		"${mygrep}" "${uuid}" "${git_mirror_dir}/uuidtable" || break
	done
	mkdir "logs/${uuid}/"
	if git clone --mirror --no-hardlinks --verbose --progress "${url}" "${uuid}" 2>&1|tee "logs/${uuid}/add-$(date '+%Y-%m-%d_%H-%M-%S').log"; then
		echo -e  "${url}\t${uuid}" >> "${git_mirror_dir}/uuidtable"
		echo -e "$(timestamp)\tADD\tSUCCESS\t${url}\t${uuid}" >> act.log
	else
		warnh "${url} corrupted. Will be skipped."
		"${myrm}" -rf "${uuid}" "logs/${uuid}/"
		echo -e "$(timestamp)\tADD\tFAILED\t${url}\t${uuid}" >> act.log
	fi
done
