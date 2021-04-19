#!/usr/bin/env bash
set -eu
DN="$(readlink -f "$(dirname "${0}")")"
PROGNAME=pathls
. "${DN}"/00_libtest.sh
DO pathls --version
DO pathls
DO pathls --no-x
DO pathls --no-o
DO pathls --no-o --no-x --allow-d
DO pathls -l
DO includels
DO includels -l
DO manls
DO manls -l
DO libls
DO libls -l
rm -rf "${TDN}"
