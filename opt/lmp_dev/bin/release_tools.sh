#!/usr/bin/env bash
set -u +e
cd "$(readlink -f "$(dirname "${0}")")"/../../../ || exit 1
. lib/libstr

# TODO: output all versions to Version.md

for item in "${@}"; do
    ${item}
done
