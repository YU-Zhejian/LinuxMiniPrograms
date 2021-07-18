#!/usr/bin/env bash
set -eu
DN="$(readlink -f "$(dirname "${0}")")"
# shellcheck disable=SC2034
PROGNAME=bhs
. "${DN}"/00_libtest.sh
__DO bhs
rm -rf "${TDN}"
