#!/usr/bin/env bash
set -eu
DN="$(readlink -f "$(dirname "${0}")")"
PROGNAME=libdo
. "${DN}"/00_libtest.sh
for LIBDO_LOG_MODE in {1..4} S;do
	DO ls -la "${HOME}" &>> /dev/null
done
# TODO: libdoman
