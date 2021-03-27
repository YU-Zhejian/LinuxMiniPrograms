#!/usr/bin/env bash
set -eu
DN="$(readlink -f "$(dirname "${0}")")"
PROGNAME=ylsjs
. "${DN}"/00_libtest.sh
. "${DN}"/../../etc/path.conf
. "${DN}"/../../lib/libman
CORENUM=$((2*$(getcorenumber)))
export YLSJSD_HOME="${PWD}/ylsjs.d"
for (( i = 0; i < CORENUM ; i ++ ));do
	echo "sleep 10" | ylsjs init &>> /dev/null
done
DO ylsjs ps
DO ylsjs ps -V -t -p -s
DO ylsjsd clear
rm -rf "${TDN}"