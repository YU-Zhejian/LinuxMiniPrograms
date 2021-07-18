#!/usr/bin/env bash
set -eu
DN="$(readlink -f "$(dirname "${0}")")"
# shellcheck disable=SC2034
PROGNAME=pss
. "${DN}"/00_libtest.sh
__DO pss
rm -rf "${TDN}"
