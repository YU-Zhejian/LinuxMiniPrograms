#!/usr/bin/env bash
set -eu
DN="$(readlink -f "$(dirname "${0}")")"
PROGNAME=yldoc
. "${DN}"/00_libtest.sh
DO yldoc
DO yldoc pathls
DO yldoc pls
rm -rf "${TDN}"
