#!/usr/bin/env bash
set -eu
DN="$(readlink -f "$(dirname "${0}")")"
# shellcheck disable=SC2034
PROGNAME=iomux
. "${DN}"/00_libtest.sh
rm -rf "${TDN}"
