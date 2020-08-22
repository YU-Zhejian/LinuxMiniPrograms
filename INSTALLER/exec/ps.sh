#!/usr/bin/env bash
# PS.sh V1P1
. "${path_sh}"
if [ -z "${myps:-}" ]; then
	GNU_found=false
	for dir in "${eachpath[@]}"; do
		! ${GNU_found} || break
		tmpf=$(mktemp -t configpath.XXXXXX)
		"${myls}" -F -1 "${dir}" | "${mygrep}" '.[*@]$' | "${mysed}" 's;[*@]$;;' | "${mygrep}" '^ps\(\.exe\)*$' | "${mysed}" "s;^;$(echo ${dir})/;" >"${tmpf}"
		while read line; do
			lntmp="${line}"
			ps_ver=$("${line}" --version 2>&1||true)
			if [[ "${ps_ver}" =~ .*"cygwin".* ]]; then
				type="Cygwin ps"
			elif [[ "${ps_ver}" =~ .*"procps-ng".* ]]; then
				GNU_found=true
				type="GNU version in GNU/Linux systems"
			else
				type="BSD version"
			fi
			echo "ps found in ${line}, ${type}"
			if ${GNU_found}; then
				echo "myps=\"${line}\" #${type}" >>"${path_sh}"
				break
			fi
		done <"${tmpf}"
		"${myrm}" "${tmpf}"
		unset tmpf dir
	done
	. "${path_sh}"
	if [ -z "${myps:-}" ]; then
		if [ -z "${lntmp:-}" ]; then
			echo "myps=\"ylukh\" #UNKNOWN" >>"${path_sh}"
			warnh "ps still not found. Please configure it manually in $(readlink -f "${path_sh}")"
		else
			warnh "Will use None-GNU ps"
			echo "myps=\"${lntmp}\" #${type}" >>"${path_sh}"
		fi
	fi
	unset ps_ver line
else
	infoh "ps configured"
fi
