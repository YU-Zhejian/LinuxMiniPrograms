#!/usr/bin/env bash
builtin set -eu
DN="$(readlink -f "$(dirname "${0}")")"
# shellcheck disable=SC2034
PROGNAME=pathls
. "${DN}"/00_libtest.sh
__DO pathls --version
__DO pathls
__DO pathls --no-x
__DO pathls --no-o
__DO pathls --no-o --no-x --allow-d
__DO pathls -l
__DO includels
__DO includels -l
__DO manls
__DO manls -l
__DO libls
__DO libls -l
rm -rf "${TDN}"
