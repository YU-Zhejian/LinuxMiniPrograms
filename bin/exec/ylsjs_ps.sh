#!/usr/bin/env bash
#YLSJS_PS v1
cd "${DN}"/../var/ylsjs.d
STDS=()
VERBOSE=false
TOP=false
PST=false
CAT=false
for opt in "${@}"; do
	if isopt "${opt}"; then
		case "${opt}" in
		"-V" | "--verbose")
			VERBOSE=true
			;;
		"-t" | "--top")
			TOP=true
			;;
		"-p" | "--pst")
			PST=true
			;;
		"-s" | "--show-sh")
			CAT=true
			;;
		esac
	else
		STDS=("${STDS[@]}" "${opt}")
	fi
done

unset STDS[0]

function __psv() {
	echo "# ---------------${1}=$("${mycat}" ${1})---------------"
	echo "    # ---------------${1}.sh---------------"
	${CAT} && "${mycat}" -n ${1}.sh
	echo "    # ---------------ps ${1}---------------"
	${PST} && pstree -ap ${1} || pss ${1}
	${TOP} && top -H -p ${1} -bc -n1
}
function __psc() {
	table=$(mktemp -t ylsjs_ps.XXXXXX)
	echo -e "#1\n#S90\n#1" > "${table}"
	echo "PID.;COMMAND;TIME" >> "${table}"
	"${myls}" -1 | "${mygrep}" -v '\.' | while read ps_name; do
		echo "${ps_name};$("${mycat}" ${ps_name});$("${DN}"/exec/datediff.sh $(stat --printf=%Z ${ps_name}) $(date +%s) s)" >> "${table}"
	done
	ylmktbl "${table}"
	"${myrm}" "${table}"
}

if [ ${#STDS[@]} -eq 0 ]; then
	if ${VERBOSE}; then
		"${myls}" -F1 | "${mygrep}" -v '\.' | while read ps_name; do
			__psv ${ps_name}
		done
	else
		__psc
	fi
else
	if ${VERBOSE}; then
		for ps_name in ${STDS}; do
			__psv ${ps_name}
		done
	fi
fi
