#!/bin/bash
# BADD V2
set -eu
DN="$(readlink -f "$(dirname "${0}")")"
. "${DN}"/etc/path.sh
grep_cmd="find . 2> /dev/null"
while read line; do
	grep_cmd="${grep_cmd} | grep -v '${line}'"
done < "${DN}"/.gitignore
dos2unix $(eval "${grep_cmd}" | xargs)
