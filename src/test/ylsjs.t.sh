#!/usr/bin/env bash
set -eu
DN="$(readlink -f "$(dirname "${0}")")"
PROGNAME=ylsjs
. "${DN}"/00_libtest.sh
. "${DN}"/../../etc/path.sh
. "${DN}"/../../lib/libman
CORENUM=$((2*$(getcorenumber)))
for (( i = 0; i < CORENUM ; i ++ ));do
	echo "sleep 10" | ylsjs init
done
ylsjs ps
ylsjs ps -V -t -p -s
ylsjsd stop
# TODO
