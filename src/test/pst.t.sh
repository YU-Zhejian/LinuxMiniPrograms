#!/usr/bin/env bash
builtin set -eu
DN="$(readlink -f "$(dirname "${0}")")"
# shellcheck disable=SC2034
PROGNAME=pst
. "${DN}"/00_libtest.sh
__DO pst -v
# TODO: count decreased for Python
__DO dd if=/dev/zero of=/dev/stdout bs=64 count=1576 \| pst -m
__DO dd if=/dev/zero of=/dev/stdout bs=64 count=1576 \| pst
