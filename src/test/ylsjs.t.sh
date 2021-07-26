#!/usr/bin/env bash
builtin set -eu
DN="$(readlink -f "$(dirname "${0}")")"
# shellcheck disable=SC2034
PROGNAME=ylsjs
. "${DN}"/00_libtest.sh
. "${DN}"/../../etc/path.conf
. "${DN}"/../../shlib/libinclude.sh
__include libman
CORENUM=$((2 * $(get_core_number)))
builtin export YLSJSD_HOME
YLSJSD_HOME="${PWD}/ylsjs.d"
__DO ylsjsd stop
for ((i = 0; i < CORENUM; i++)); do
    builtin echo "sleep 1" | __DO ylsjs init
done
__DO ylsjs ps
__DO ylsjs ps -V -t -p -s
__DO ylsjsd clear

