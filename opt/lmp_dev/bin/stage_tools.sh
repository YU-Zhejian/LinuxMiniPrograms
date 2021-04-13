#!/usr/bin/env bash
set -u +e
cd "$(readlink -f "$(dirname "${0}")")"/../../../
. lib/libstr
function rm_crlf(){
	if which dos2unix &>>/dev/null; then
		/usr/bin/find . -path './.git' -prune -o -type f -print | while read fn; do dos2unix "${fn}"; done
	else
		/usr/bin/find . -path './.git' -prune -o -type f -print | xargs file | grep text | cut -d: -f1 | while read fn; do
			echo "${fn}"
			sed -i'.bak' 's/\'$'\r$//g' "${fn}"
			echo "Beforeadd finished. Please remove the .bak files manually"
		done
	fi
}

function bump_verson(){
	git status | grep '^\smodified:\s' | cut -f 2 -d ':' | while read line; do
		line="$(trimstr "${line}")"
		if ! file ${line} | grep text &>>/dev/null; then
			continue
		fi
		infoh "Modifying ${line}..."
		smallVersion=$(grep 'VERSION=' "${line}" | head -n 1 | cut -f 2 -d '.')
		smallVersion=$((${smallVersion} + 1))
		sed -i'.bak' 's;VERSION=\([0-9]*\)\.\([0-9]*\)$;VERSION=\1.'"$(echo ${smallVersion})"';' "${line}"
	done
}
function rm_bak(){
	/usr/bin/find . -path './.git' -prune -o -type f -print | grep '\.bak$' | while read fn; do rm -v "${fn}"; done
}

