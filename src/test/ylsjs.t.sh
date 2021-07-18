#!/usr/bin/env bash
set -eu
DN="$(readlink -f "$(dirname "${0}")")"
# shellcheck disable=SC2034
PROGNAME=ylsjs
. "${DN}"/00_libtest.sh
. "${DN}"/../../etc/path.conf
. "${DN}"/../../lib/libman
CORENUM=$((2 * $(getcorenumber)))
export YLSJSD_HOME="${PWD}/ylsjs.d"
__DO ylsjsd stop
for ((i = 0; i < CORENUM; i++)); do
    echo "sleep 1" | __DO ylsjs init
done
__DO ylsjs ps
__DO ylsjs ps -V -t -p -s
__DO ylsjsd clear
rm -rf "${TDN}"
