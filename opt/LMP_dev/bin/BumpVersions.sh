#!/usr/bin/env bash
set -ue
VERSION=1.2
cd "$(readlink -f "$(dirname "${0}")")"/../../../
. lib/libstr
git status | grep '^\smodified:\s' | cut -f 2 -d ':' | while read line; do
	line="$(trimstr "${line}")"
	if ! file ${line} | grep text &>> /dev/null;then
		continue
	fi
	infoh "Modifying ${line}..."
	smallVersion=$(grep 'VERSION=' "${line}" | head -n 1 | cut -f 2 -d '.')
	smallVersion=$((${smallVersion}+1))
	sed -i'.bak' 's;VERSION=\([0-9]*\)\.\([0-9]*\)$;VERSION=\1.'"$(echo ${smallVersion})"';' "${line}"
done
