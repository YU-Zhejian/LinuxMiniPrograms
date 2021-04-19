#!/usr/bin/env bash
VERSION=1.2
. "${path_sh}"
if [ -z "${mypython:-}" ]; then
	python_ver=3
	for dir in "${eachpath[@]}"; do
		tmpf=$(mktemp -t configpath.XXXXXX)
		ls -F -1 "${dir}" | grep '.[*@]$' | sed 's;[*@]$;;' | grep -E '^(python(3|2){0,1}(\.[[:digit:]]+)*(d|m|u){0,1}(.exe){0,1}$)' | sed "s;^;$(echo ${dir})/;" >"${tmpf}"
		while read line; do
			if echo "exit()" | "${line}" -v 2>&1 | grep -E '([C-Z]:\\)' >/dev/null; then
				infoh "Windows Python found in ${line}"
				continue
			fi
			echo "Python found in ${line}"
			curr_version=$("${line}" --version 2>&1 | cut -f 2 -d " ")
			if [[ "${curr_version}" == 3* ]] && [ $(expr "${curr_version}" \>= "${python_ver}") -eq 1 ]; then
				Out_C="${line}"
				python_ver="${curr_version}"
				break 2 # Use fast mode
			fi
			unset curr_version line
		done <"${tmpf}"
		rm "${tmpf}"
		unset tmpf dir
	done
	if [ -n "${Out_C:-}" ]; then
		echo "mypython=\"${Out_C}\" #version ${python_ver}" >>"${path_sh}"
		echo "Python found in ${Out_C}, version ${python_ver}"
		unset Out_C
	else
		echo "mypython=\"ylukh\" #UNKNOWN" >>"${path_sh}"
		warnh "Python still not found. Please configure it manually in $(readlink -f "${path_sh}")"
	fi
	unset python_ver
	. "${path_sh}"
else
	infoh "python configured"
fi
