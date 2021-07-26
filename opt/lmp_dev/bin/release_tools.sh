#!/usr/bin/env bash
builtin set -u +e
builtin cd "$(readlink -f "$(dirname "${0}")")"/../../../ || builtin exit 1
./shlib/libinclude.sh

__include libstr

# TODO: output all versions to Version.md

for item in "${@}"; do
    ${item}
done
