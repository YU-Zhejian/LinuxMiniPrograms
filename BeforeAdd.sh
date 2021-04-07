#!/usr/bin/env bash
set -u +e
cd "$(readlink -f "$(dirname "${0}")")"
if which dos2unix &>> /dev/null;then
	/usr/bin/find . -path './.git' -prune -o -type f -print | while read fn; do dos2unix "${fn}"; done
else
	# TODO: test here.
	/usr/bin/find . -path './.git' -prune -o -type f -print | xargs file | grep text  | cut -d: -f1 | while read fn;do echo "${fn}"; sed -i 's/\'$'\r$//g' "${fn}"; done
fi
