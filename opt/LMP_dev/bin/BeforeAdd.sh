#!/usr/bin/env bash
set -u +e
cd "$(readlink -f "$(dirname "${0}")")"/../../../
if which dos2unix &>> /dev/null;then
	/usr/bin/find . -path './.git' -prune -o -type f -print | while read fn; do dos2unix "${fn}"; done
else
	/usr/bin/find . -path './.git' -prune -o -type f -print | xargs file | grep text  | cut -d: -f1 | while read fn;do
		echo "${fn}"
		sed -i'.bak' 's/\'$'\r$//g' "${fn}"
		echo "Beforeadd finished. Please remove the .bak files manually"
	done
fi
