#!/usr/bin/env bash
# PARALLEL.sh V1P1
. "${path_sh}"
if [ -z "${myparallel:-}" ]; then
	GNU_found=false
	for dir in "${eachpath[@]}"; do
		! ${GNU_found} || break
		tmpf=$(mktemp -t configpath.XXXXXX)
		"${myls}" -F -1 "${dir}" | "${mygrep}" '.[*@]$' | "${mysed}" 's;[*@]$;;' | "${mygrep}" '^parallel\(\.exe\)*$' | "${mysed}" "s;^;$(echo ${dir})/;" > "${tmpf}"
		while read line; do
			echo "will cite\n" | "${line}" --citation &>> /dev/null || true
			parallel_ver=$("${line}" --version 2>&1 || true)
			if [[ "${parallel_ver}" == *"GNU"* ]]; then
				GNU_found=true
				type="GNU version"
				echo "parallel found in ${line}, ${type}"
				echo "myparallel=\"${line}\" #${type}" >> "${path_sh}"
				break
			fi
			unset type
		done < "${tmpf}"
		"${myrm}" "${tmpf}"
		unset tmpf dir
	done
	. "${path_sh}"
	if [ -z "${myparallel:-}" ]; then
		echo "myparallel=\"ylukh\" #UNKNOWN" >> "${path_sh}"
		warnh "parallel still not found. Please configure it manually in $(readlink -f "${path_sh}")"
	fi
	unset parallel_ver line
else
	infoh "parallel configured"
fi
