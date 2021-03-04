#!/usr/bin/env bash
# PLS.sh V3P3
oldifs="${IFS}"
function _grep() {
	regstr="${1}"
	local tmpff=$(mktemp -t pls.XXXXXX)
	cat "${tmpf}" | grep -v "${regstr}" > "${tmpff}"
	mv "${tmpff}" "${tmpf}"
}
. "${DN}"/../lib/libisopt
INPATH="${PATH}"
. "${DN}"/../lib/libpath
IFS=":"
eachpath=(${valid_path})
unset duplicated_path
IFS=''
allow_x=true
allow_d=false
allow_o=true
STDS=()
for opt in "${@}"; do
	if isopt "${opt}"; then
		case "${opt}" in
		"-h" | "--help")
			yldoc pathls
			exit 0
			;;
		"-v" | "--version")
			echo "Version 3 Patch 3"
			exit 0
			;;
		"--no-x")
			allow_x=false
			;;
		"--allow-d")
			allow_d=true
			;;
		"--no-o")
			allow_o=false
			;;
		"-l" | "--list")
			echo ${valid_path} | tr ':' '\n'
			unset valid_path
			exit 0
			;;
		"-i" | "--invalid")
			echo ${invalid_path} | tr ':' '\n'
			unset invalid_set invalid_path valid_path
			exit 0
			;;
		"-x")
			set -x
			;;
		*)
			warnh "Option '${opt}' invalid. Ignored"
			;;
		esac
	else
		STDS=("${STDS[@]}" "${opt}")
	fi
done
unset invalid_path valid_path
tmpf="$(mktemp -t pls.XXXXXX)"
infoh "Reading database..."
for dir in "${eachpath[@]}"; do
	ls -1 -F "${dir}" 2> /dev/null | sed "s;^;$(echo "${dir}")/;" >> "${tmpf}" || true
done
${allow_d} || _grep '/$'
${allow_x} || _grep '\*$'
${allow_o} || _grep '[^\*/]$'
if [ ${#STDS[@]} -eq 0 ]; then
	cat "${tmpf}"
else
	IFS=''
	grepstr=''
	for fn in "${STDS[@]}"; do
		grepstr="${grepstr} -e ${fn}"
	done
	eval cat \"${tmpf}\"\|grep "${grepstr}"
fi
rm "${tmpf}"
IFS="${oldifs}"
