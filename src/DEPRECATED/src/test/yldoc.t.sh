#!/usr/bin/env bash
builtin set -eu
DN="$(readlink -f "$(dirname "${0}")")"
# shellcheck disable=SC2034
PROGNAME=yldoc
. "${DN}"/00_libtest.sh
__DO yldoc
__DO yldoc pathls
__DO yldoc pls

