#!/usr/bin/env bash
set +e -u
DN="$(readlink -f "$(dirname "${0}")")"
cd "${DN}"
. ../../lib/libstr
infoh "Performing tests..."
for fn in "${DN}"/*.t.sh;do
	printf "Executing ${fn}..."
	bash "${fn}" && echo "PASS" || echo "FAIL"
done
