#!/usr/bin/env bash
# PLS.sh V3P3
oldifs="${IFS}"
function my_grep() {
	regstr="${1}"
	local tmpff=$(mktemp -t pls.XXXXXX)
	"${mycat}" "${tmpf}" | "${mygrep}" -v "${regstr}" > "${tmpff}"
	"${mymv}" "${tmpff}" "${tmpf}"
}
more="${mymore}"
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
		--more\:*)
			more=$"{opt:7}"
			if $(
				"${more}" --help &> /dev/null
				echo ${?}
			) -eq 127; then
				warnh "Invalid More '${more}'! Will use original '${mymore}' instead"
				more="${mymore}"
			else
				infoh "Will use '${more}' as More"
			fi
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
	"${myls}" -1 -F "${dir}" 2> /dev/null | "${mysed}" "s;^;$(echo "${dir}")/;" >> "${tmpf}" || true
done
${allow_d} || my_grep '/$'
${allow_x} || my_grep '\*$'
${allow_o} || my_grep '[^\*/]$'
if [ ${#STDS[@]} -eq 0 ]; then
	"${mycat}" "${tmpf}" | "${more}"
else
	IFS=''
	grepstr=''
	for fn in "${STDS[@]}"; do
		grepstr="${grepstr} -e ${fn}"
	done
	eval "${mycat}" \"${tmpf}\"\|"${mygrep}" "${grepstr}"\|"${more}"
fi
"${myrm}" "${tmpf}"
IFS="${oldifs}"
