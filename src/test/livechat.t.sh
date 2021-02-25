#!/usr/bin/env bash
set -eu
DN="$(readlink -f "$(dirname "${0}")")"
PROGNAME=livechat
. "${DN}"/00_libtest.sh
# TODO: Fix bugs in livechat
# DO yldoc \| livechat tester
DO lcman
DO lcman -m:"quitted"
DO lcman -s
DO lcman -e:"SYSTEM"
DO lcman -f:"SYSTEM"
