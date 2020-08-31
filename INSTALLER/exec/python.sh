#!/usr/bin/env bash
# PYTHON.sh V1P1
. "${path_sh}"
if [ -z "${mypython:-}" ]; then
	python_ver=3
	for dir in "${eachpath[@]}"; do
		tmpf=$(mktemp -t configpath.XXXXXX)
		"${myls}" -F -1 "${dir}" | "${mygrep}" '.[*@]$' | "${mysed}" 's;[*@]$;;' | "${mygrep}" -E '^(python(3|)(\.[[:digit:]]+)*(d|m|u|)(.exe|)$)' | "${mysed}" "s;^;$(echo ${dir})/;" >"${tmpf}"
		while read line; do
			echo "Python found in ${line}"
			curr_version=$("${line}" --version 2>&1 | cut -f 2 -d " ")
			if [[ "${curr_version}" == 3* ]] && [ $(expr "${curr_version}" \>= "${python_ver}") -eq 1 ]; then
				Out_C="${line}"
				python_ver="${curr_version}"
			fi
			unset curr_version line
		done <"${tmpf}"
		"${myrm}" "${tmpf}"
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
