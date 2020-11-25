#!/usr/bin/env bash
# LS.sh V1P1
. "${path_sh}"
if [ -z "${myls:-}" ]; then
	GNU_found=false
	for dir in "${eachpath[@]}"; do
		! ${GNU_found} || break
		tmpf=$(mktemp -t configpath.XXXXXX)
		ls -F -1 "${dir}" | grep '.\*$' | sed "s;\*\$;;" | grep '^ls\(\.exe\)*$' | sed "s;^;$(echo ${dir})/;" > "${tmpf}"
		while read line; do
			lntmp="${line}"
			ls_ver=$("${line}" --version 2>&1 || true)
			if [[ "${ls_ver}" == *"GNU"* ]]; then
				GNU_found=true
				[[ "${ls_ver}" == *"Cygwin"* ]] && type="GNU version in Cygwin systems" || type="GNU version in GNU/Linux systems"
			else
				type="BSD version"
			fi
			echo "ls found in ${line}, ${type}"
			if ${GNU_found}; then
				echo "myls=\"${line}\" #${type}" >> "${path_sh}"
				break
			fi
		done < "${tmpf}"
		rm "${tmpf}"
		unset tmpf dir
	done
	. "${path_sh}"
	if [ -z "${myls:-}" ]; then
		if [ -z "${lntmp:-}" ]; then
			echo "myls=\"ylukh\" #UNKNOWN" >> "${path_sh}"
			warnh "ls still not found. Please configure it manually in ${path_sh}"
		else
			warnh "Will use BSD ls"
			echo "myls=\"${lntmp}\" #${type}" >> "${path_sh}"
		fi
	fi
	unset ls_ver line
else
	infoh "ls configured"
fi
