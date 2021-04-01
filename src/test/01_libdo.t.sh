#!/usr/bin/env bash
set -eux
DN="$(readlink -f "$(dirname "${0}")")"
PROGNAME=libdo
. "${DN}"/00_libtest.sh
for LIBDO_LOG_MODE in {1..4} S;do
	DO ls -la "${HOME}" &>> /dev/null
done
LIBDO_LOG_MODE=4
LIBDO_LOG=libdo2.log
for i in {1..4};do
	DO ls -la "${HOME}"
done
DO libdoman libdo2.log
DO libdoman -m libdo2.log
DO libdoman -o:1 libdo2.log
rm -rf "${TDN}"
