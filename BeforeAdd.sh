#!/usr/bin/env bash
set -u +e
DN="$(readlink -f "$(dirname "${0}")")"
cd "${DN}"
if which dos2unix &>> /dev/null;then
	/usr/bin/find . -path './.git' -prune -o -type f -print | while read fn; do dos2unix "${fn}"; done
else
	true
	# TODO: bugs here.
	# /usr/bin/find . -path './.git' -prune -o -type f -print | while read fn;do sed -i 's/\'$'\r$//g' "${fn}"; done
fi
