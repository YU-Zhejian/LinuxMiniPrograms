#!/usr/bin/env bash
builtin set -eu
DN="$(readlink -f "$(dirname "${0}")")"
# shellcheck disable=SC2034
PROGNAME=livechat
. "${DN}"/00_libtest.sh
__DO builtin echo '!ls' \| livechat tester
__DO lcman
__DO lcman -m:"quitted"
__DO lcman -s
__DO lcman -e:"SYSTEM"
__DO lcman -f:"SYSTEM"
rm -rf "${TDN}"
