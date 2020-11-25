#!/usr/bin/env bash
# SED.sh V1P1
. "${path_sh}"
if [ -z "${mysed:-}" ]; then
	GNU_found=false
	for dir in "${eachpath[@]}"; do
		! ${GNU_found} || break
		tmpf=$(mktemp -t configpath.XXXXXX)
		"${myls}" -F -1 "${dir}" | "${mygrep}" '.[*@]$' | sed "s;\*\$;;" | "${mygrep}" '^sed\(\.exe\)*$' | sed "s;^;$(echo ${dir})/;" > "${tmpf}"
		while read line; do
			lntmp="${line}"
			sed_ver=$("${line}" --version 2>&1 || true)
			if [[ "${sed_ver}" == *"GNU"* ]]; then
				GNU_found=true
				[[ "${sed_ver}" == *"Cygwin"* ]] && type="GNU version in Cygwin systems" || type="GNU version in GNU/Linux systems"
			else
				type="BSD version"
			fi
			echo "sed found in ${line}, ${type}"
			if ${GNU_found}; then
				echo "mysed=\"${line}\" #${type}" >> "${path_sh}"
				break
			fi
		done < "${tmpf}"
		rm "${tmpf}"
		unset tmpf dir
	done
	. "${path_sh}"
	if [ -z "${mysed:-}" ]; then
		if [ -z "${lntmp:-}" ]; then
			echo "mysed=\"ylukh\" #UNKNOWN" >> "${path_sh}"
			warnh "sed still not found. Please configure it manually in $(readlink -f "${path_sh}")"
		else
			warnh "Will use BSD sed"
			echo "mysed=\"${lntmp}\" #${type}" >> "${path_sh}"
		fi
	fi
	unset sed_ver line
else
	infoh "sed configured"
fi
