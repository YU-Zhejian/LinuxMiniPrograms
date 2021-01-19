#!/usr/bin/env bash
#YLSJS_PS v1
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
	local PID
	for ps_name in "${@}"; do
		if [ -f "${ps_name}" ]; then
			PID=$("${mycat}" ${ps_name} | tail -n 1)
			echo "# ---------------No=${ps_name}, NAME=$("${mycat}" ${ps_name} | head -n 1), PID=${PID}---------------"
			if ${CAT};then
				echo "    # ---------------Submitted ${ps_name}.sh---------------"
				"${mycat}" -n ${ps_name%.*}.sh
			fi
			echo "    # ---------------ps ${ps_name}---------------"
			ps -p ${PID} || true
			${PST} && pstree -ap ${PID} || true
			${TOP} && top -H -p ${PID} -bc -n1 || true
		fi
	done
}

function __psc() {
	table=$(mktemp -t ylsjs_ps.XXXXXX)
	echo -e "#1\n#1\n#1\n#1\n#1" >"${table}"
	echo "NO.;NAME;PID;EXECTIME;STATUS" >>"${table}"
	for ps_name in "${@}"; do
		[ -f "${ps_name}" ] && echo "${ps_name};$("${mycat}" ${ps_name} | xargs | tr ' ' ';' );$(bash "${DN}"/exec/datediff.sh $(stat --printf=%Z ${ps_name}) $(date +%s) s);EXEC" >>"${table}"
		[ -f "${ps_name}.q" ] && echo "${ps_name};$("${mycat}" ${ps_name} | xargs | tr ' ' ';');$(bash "${DN}"/exec/datediff.sh $(stat --printf=%Z ${ps_name}) $(date +%s) s);PEND" >>"${table}"
		[ -f "${ps_name}.f" ] && echo "${ps_name};$("${mycat}" ${ps_name} | xargs | tr ' ' ';');$(bash "${DN}"/exec/datediff.sh $(stat --printf=%Z ${ps_name}) $(date +%s) s);DONE" >>"${table}"
	done
	# cat "${table}"
	ylmktbl "${table}"
	"${myrm}" "${table}"
}


if [ ${#STDS[@]} -eq 0 ]; then
	if ${VERBOSE}; then
		__psv $("${myls}" -1 | "${mygrep}" '^[0-9]\(\.[qf]\)*$' | xargs)
	else
		__psc $("${myls}" -1 | "${mygrep}" '^[0-9]\(\.[qf]\)*$' | xargs)
	fi
else
	if ${VERBOSE}; then
		__psv "${STDS[@]}"
	else
		__psc "${STDS[@]}"
	fi
fi
