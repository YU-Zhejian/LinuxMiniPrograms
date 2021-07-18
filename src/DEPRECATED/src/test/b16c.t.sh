#!/usr/bin/env bash
set -eu
DN="$(readlink -f "$(dirname "${0}")")"
# shellcheck disable=SC2034
PROGNAME=b16c
. "${DN}"/00_libtest.sh
sha512sum="sha512sum"
! which sha512sum &>>/dev/null && sha512sum="gsha512sum" # For compatibility under FreeBSD
__DO b16c --version
__DO cat /bin/ls \| "${sha512sum}" \> ls.512
__DO cat /bin/ls \| b16c \| b16c -d \| "${sha512sum}" -c ls.512 &>>/dev/null
__DO enigma --version
__DO enigma -g
__DO cat /bin/ls \| b16c \| enigma -c:1 -s:B \| enigma -c:1 -s:B -d \| b16c -d \| "${sha512sum}" -c ls.512 &>>/dev/null
rm -rf "${TDN}"
