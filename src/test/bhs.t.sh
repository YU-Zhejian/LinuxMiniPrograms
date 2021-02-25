#!/usr/bin/env bash
set -eu
DN="$(readlink -f "$(dirname "${0}")")"
PROGNAME=bhs
. "${DN}"/00_libtest.sh
DO bhs
