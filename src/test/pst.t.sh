#!/usr/bin/env bash
set -eu
DN="$(readlink -f "$(dirname "${0}")")"
PROGNAME=pst
. "${DN}"/00_libtest.sh
# TODO
