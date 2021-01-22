#!/usr/bin/env bash
set -eu
DN="$(readlink -f "$(dirname "${0}")")"
cd "${DN}"
grep_cmd="find . 2> /dev/null | grep -v '.git'"
cat "${DN}"/.gitignore | grep -v '^$' | grep -v '^#' > gitignore.tmp
 while read line; do
	grep_cmd="${grep_cmd} | grep -v '${line}'"
done < gitignore.tmp
rm gitignore.tmp
dos2unix $(eval "${grep_cmd}" | xargs)
