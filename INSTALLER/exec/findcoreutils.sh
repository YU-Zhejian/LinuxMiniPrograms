#!/usr/bin/env bash
# FINDCOREUTILS.sh V2
if ! "${mygrep}" ^"my${PROGNAME}"= "${path_sh}";then
	GNU_found=false
	for dir in "${eachpath[@]}"; do
		! ${GNU_found} || break
		tmpf=$(mktemp -t configpath.XXXXXX)
		"${myls}" -F -1 "${dir}" | "${mygrep}" '.[*@]$' | "${mysed}" 's;[*@]$;;' | "${mygrep}" '^'"${PROGNAME}"'\(\.exe\)*$' | "${mysed}" "s;^;$(echo ${dir})/;" >"${tmpf}"
		while read line; do
			lntmp="${line}"
			PROG_ver=$("${line}" --version 2>&1||true)
			if [[ "${PROG_ver}" == *"GNU"* ]]; then
				GNU_found=true
				[[ "${PROG_ver}" == *"Cygwin"* ]] && type="GNU version in Cygwin systems" || type="GNU version in GNU/Linux systems"
			else
				type="BSD version"
			fi
			echo "${PROGNAME} found in ${line}, ${type}"
			if ${GNU_found}; then
				echo "my${PROGNAME}=\"${line}\" #${type}" >>"${path_sh}"
				break
			fi
		done <"${tmpf}"
		"${myrm}" "${tmpf}"
		unset tmpf dir
	done
	if ! "${mygrep}" ^"my${PROGNAME}"= "${path_sh}";then
		if [ -z "${lntmp:-}" ]; then
			echo "my${PROGNAME}=\"ylukh\" #UNKNOWN" >>"${path_sh}"
			warnh "${PROGNAME} still not found. Please configure it manually in $(readlink -f "${path_sh}")"
		else
			warnh "Will use BSD ${PROGNAME}"
			echo "my${PROGNAME}=\"${lntmp}\" #${type}" >>"${path_sh}"
		fi
	fi
	unset PROG_ver line
else
	infoh "${PROGNAME} configured"
fi
