#!/usr/bin/env bash
# GREP.sh V1P1
. "${path_sh}"
if [ -z "${mygrep:-}" ]; then
	GNU_found=false
	for dir in "${eachpath[@]}"; do
		! ${GNU_found} || break
		tmpf=$(mktemp -t configpath.XXXXXX)
		"${myls}" -F -1 "${dir}" | grep '.\*$' | sed "s;\*\$;;" | grep '^grep\(\.exe\)*$' | sed "s;^;$(echo ${dir})/;" >"${tmpf}"
		while read line; do
			grep_ver=$("${line}" --version 2>&1||true)
			if [[ "${grep_ver}" =~ .*"GNU".* ]]; then
				if [[ "${grep_ver}" =~ .*"BSD".* ]]; then
					type="GNU version in BSD systems"
				elif [[ "${grep_ver}" =~ .*"Cygwin".* ]]; then
					type="GNU version in Cygwin systems"
				else
					type="GNU version in GNU/Linux systems"
				fi
				echo "grep found in ${line}, ${type}"
				echo "mygrep=\"${line}\" #${type}" >>"${path_sh}"
				break
			fi
		done <"${tmpf}"
		rm "${tmpf}"
		unset tmpf dir grep_ver line
	done
	. "${path_sh}"
	if [ -z "${mygrep:-}" ]; then
		echo "mygrep=\"ylukh\" #UNKNOWN" >>"${path_sh}"
		warnh "grep still not found. Please configure it manually in $(readlink -f "${path_sh}")"
	fi
else
	infoh "grep configured"
fi
