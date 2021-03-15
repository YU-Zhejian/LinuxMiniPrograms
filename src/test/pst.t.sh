#!/usr/bin/env bash
set -eu
DN="$(readlink -f "$(dirname "${0}")")"
PROGNAME=pst
. "${DN}"/00_libtest.sh
DO pst -v
DO dd if=/dev/zero of=/dev/stdout bs=64 count=1048576 \| pst -m
DO dd if=/dev/zero of=/dev/stdout bs=64 count=1048576 \| pst
rm -rf "${TDN}"
