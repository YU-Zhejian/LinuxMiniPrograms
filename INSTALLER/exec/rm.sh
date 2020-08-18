#!/usr/bin/env bash
# RM.sh V1P1
. "${path_sh}"
if [ -z "${myrm:-}" ]; then
	GNU_found=false
	for dir in "${eachpath[@]}"; do
		${GNU_found} && break || true
		tmpf=$(mktemp -t configpath.XXXXXX)
		"${myls}" -F -1 "${dir}" | "${mygrep}" '.[*@]$' | "${mysed}" 's;[*@]$;;' | "${mygrep}" '^rm\(\.exe\)*$' | "${mysed}" "s;^;$(echo ${dir})/;" >"${tmpf}"
		while read line; do
			lntmp="${line}"
			rm_ver=$("${line}" --version 2>&1||true)
			if [[ "${rm_ver}" =~ .*"GNU".* ]]; then
				GNU_found=true
				[[ "${rm_ver}" =~ .*"Cygwin".* ]] && type="GNU version in Cygwin systems" || type="GNU version in GNU/Linux systems"
			else
				type="BSD version"
			fi
			echo "rm found in ${line}, ${type}"
			if ${GNU_found}; then
				echo "myrm=\"${line}\" #${type}" >>"${path_sh}"
				break
			fi
		done <"${tmpf}"
		rm "${tmpf}"
		unset tmpf dir
	done
	. "${path_sh}"
	if [ -z "${myrm:-}" ]; then
		if [ -z "${lntmp:-}" ]; then
			echo "myrm=\"ylukh\" #UNKNOWN" >>"${path_sh}"
			warnh "rm still not found. Please configure it manually in $(readlink -f "${path_sh}")"
		else
			warnh "Will use BSD rm"
			echo "myrm=\"${lntmp}\" #${type}" >>"${path_sh}"
		fi
	fi
	unset rm_ver line
else
	infoh "rm configured"
fi
