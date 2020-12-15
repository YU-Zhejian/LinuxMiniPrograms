#!/usr/bin/env bash
# BUILD C_SRC V1
set -eu
OLDIFS="${IFS}"
DN="$(readlink -f "$(dirname "${0}")")"
cd "${DN}"
. ../../etc/path.sh
make
for fn in src/*/bin/*;do
	"${mymv}" "${fn}" ../../bin/exec/"$(basename "${fn}")"
done
