#!/usr/bin/env bash
set -eu
DN="$(readlink -f "$(dirname "${0}")")"
PROGNAME=libdosh
. "${DN}"/00_libtest.sh
exit 0
